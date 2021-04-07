# -*- coding: utf-8 -*-
#
#
#  Luan Araújo Haickell
#  Gabriel Pires Iduarte
#
#  Código para enviar referência do angulo e coletar os dados Y0 e U0 para realizar técnica FRIT
#
#

import logging
import time
import math

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.crazyflie.syncLogger import SyncLogger

T = 5
pontos = [0, 20, -15, -20, 42, -37, 10]

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)

if __name__ == '__main__':
    # Initialize the low-level drivers (don't list the debug drivers)
    cflib.crtp.init_drivers(enable_debug_driver=False)
    available = cflib.crtp.scan_interfaces()

    if len(available) == 0:
        print('No Crazyflies found,     cannot run example')
    else:
        period_in_ms=10
        lg_stab = LogConfig(name='Stabilizer', period_in_ms=10)
        lg_stab.add_variable('pm.batteryLevel', 'uint8_t')

        
        #Realimentação PID rate 
        lg_stab.add_variable('stateEstimate.pitch', 'float')
        lg_stab.add_variable('stateEstimate.roll', 'float')
        lg_stab.add_variable('controller.pitchRate', 'float')
        lg_stab.add_variable('controller.rollRate', 'float')
        i = 0
        
        #print("antes")
        cf = Crazyflie(rw_cache='./cache')
        #print("antes 2")
        with SyncCrazyflie(available[0][0], cf=cf) as scf:
            #cf.param.set_value('pid_attitude.pitch_kp', '1.7344')
            #cf.param.set_value('pid_attitude.pitch_ki', '0.0445')
            #cf.param.set_value('pid_attitude.pitch_kd', '0')
            cf.param.set_value('pid_attitude.pitch_kp', '6')
            cf.param.set_value('pid_attitude.pitch_ki', '3')
            cf.param.set_value('pid_attitude.pitch_kd', '0')
            
            cf.param.set_value('flightmode.stabModePitch', '1')
            time.sleep(0.1)
            cf.param.set_value('flightmode.stabModeRoll', '1')
            time.sleep(0.1)
            #cf.param.set_value('pid_attitude.pitch_kp', '2')
            #cf.param.set_value('pid_attitude.pitch_ki', '0')
            #cf.param.set_value('pid_attitude.pitch_kd', '0')

            cf.param.set_value('kalman.resetEstimation', '1')
            time.sleep(0.1)
            cf.param.set_value('kalman.resetEstimation', '0')
            time.sleep(0.1)
            cf.commander.send_setpoint(0, 0, 0, 0)
            time.sleep(1)
            
            
            with SyncLogger(scf, lg_stab) as logger:
                thrust = 20000
                pitch = 0
                roll = 0
                yawrate = 0
                # Unlock startup thrust protection
                cf.commander.send_setpoint(0, 0, 0, 0)

                #print("depois")
                startTime = time.time()

                for log_entry in logger:
                    timestamp = log_entry[0]
                    data = log_entry[1]
                    #logconf_name = log_entry[2]
                    nowTime = time.time() - startTime
                    if nowTime < T*len(pontos):
                        t0 = math.trunc(nowTime / T)
                        mag = pontos[t0]
                        pitch = mag * math.pow(2,(-(nowTime - t0*T)))
                    
                    else:
                        pitch = 0
                        cf.commander.send_setpoint(0, 0, 0, 0)
                        break

                    cf.commander.send_setpoint(roll, pitch, yawrate, thrust)
                    time.sleep(period_in_ms/1000)
                    print('\'time\': %d,%s,\'ref_gx\':%f,\'ref_gy\': %f, \'ref_gz\': %f #' % (timestamp, data, roll, pitch, yawrate))
                