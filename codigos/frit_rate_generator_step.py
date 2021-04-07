# -*- coding: utf-8 -*-
#
#  Luan Araújo Haickell
#  Gabriel Pires Iduarte
#
#  Código para enviar referência de rate e coletar os dados Y0 e U0 para realizar técnica FRIT
#

import logging
import time
import math

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.crazyflie.syncLogger import SyncLogger

# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)

if __name__ == '__main__':
    # Initialize the low-level drivers (don't list the debug drivers)
    cflib.crtp.init_drivers(enable_debug_driver=False)
    available = cflib.crtp.scan_interfaces()

    if len(available) == 0:
        print('No Crazyflies found, cannot run example')
    else:
        period_in_ms=10
        lg_stab = LogConfig(name='Stabilizer', period_in_ms=10)
        lg_stab.add_variable('pm.batteryLevel', 'uint8_t')
        
        #Realimentação PID rate 
        #lg_stab.add_variable('gyro.yRaw', 'float')
        #lg_stab.add_variable('gyro.xRaw', 'float')
        #lg_stab.add_variable('gyro.zRaw', 'float')
        lg_stab.add_variable('stateEstimateZ.rateRoll', 'int16_t')
        lg_stab.add_variable('stateEstimateZ.ratePitch', 'int16_t')
        lg_stab.add_variable('stateEstimateZ.rateYaw', 'int16_t')
        lg_stab.add_variable('controller.cmd_roll', 'float')
        lg_stab.add_variable('controller.cmd_pitch', 'float')
        lg_stab.add_variable('controller.cmd_yaw', 'float')
        i = 0
        
        #print("antes")
        cf = Crazyflie(rw_cache='./cache')
        #print("antes 2")
        with SyncCrazyflie(available[0][0], cf=cf) as scf:
            cf.param.set_value('flightmode.stabModePitch', '0')
            time.sleep(0.1)
            cf.param.set_value('flightmode.stabModeRoll', '0')
            time.sleep(0.1)
            cf.param.set_value('kalman.resetEstimation', '1')
            time.sleep(0.1)
            cf.param.set_value('kalman.resetEstimation', '0')
            time.sleep(0.1)
            cf.commander.send_setpoint(0, 0, 0, 0)
            time.sleep(2)
            
            
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
                    if nowTime < 5:
                        pitch = 8
                    elif nowTime < 10:
                        pitch = -8
                    elif nowTime < 15:
                        pitch = 8
                    else:
                        pitch = 0
                        cf.commander.send_setpoint(0, 0, 0, 0)
                        break

                    cf.commander.send_setpoint(roll, pitch, yawrate, thrust)
                    time.sleep(period_in_ms/1000)
                    print('\'time\': %d,%s,\'ref_gx\':%f,\'ref_gy\': %f, \'ref_gz\': %f #' % (timestamp, data, roll, pitch, yawrate))
                