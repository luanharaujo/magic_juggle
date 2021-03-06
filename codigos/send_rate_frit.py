# -*- coding: utf-8 -*-
#
#     ||          ____  _ __
#  +------+      / __ )(_) /_______________ _____  ___
#  | 0xBC |     / __  / / __/ ___/ ___/ __ `/_  / / _ \
#  +------+    / /_/ / / /_/ /__/ /  / /_/ / / /_/  __/
#   ||  ||    /_____/_/\__/\___/_/   \__,_/ /___/\___/
#
#  Copyright (C) 2016 Bitcraze AB
#
#  Crazyflie Nano Quadcopter Client
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA  02110-1301, USA.
"""
Código para enviar referencia para rate e coletar os dados
"""
import logging
import time

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
        lg_stab.add_variable('gyro.yRaw', 'float')
        lg_stab.add_variable('gyro.xRaw', 'float')
        lg_stab.add_variable('gyro.zRaw', 'float')
        lg_stab.add_variable('stateEstimateZ.ratePitch', 'int16_t')
        lg_stab.add_variable('stateEstimate.pitch', 'float')
        lg_stab.add_variable('stateEstimateZ.rateYaw', 'int16_t')
        #lg_stab.add_variable('controller.r_roll', 'float')
        #lg_stab.add_variable('controller.r_pitch', 'float')
        #lg_stab.add_variable('stabilizer.pitch', 'float')
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
                direction_time = 3

                for log_entry in logger:
                    timestamp = log_entry[0]
                    data = log_entry[1]
                    #logconf_name = log_entry[2]
                    nowTime = time.time()
                    if nowTime < startTime + 5*direction_time:
                        pitch = 10
                    #elif nowTime > startTime + direction_time and nowTime < startTime + 2*direction_time:
                    #    pitch = 0
                    #elif nowTime > startTime + 2*direction_time and nowTime < startTime + 4*direction_time:
                    #    pitch = -10
                    #elif nowTime > startTime + 4*direction_time and nowTime < startTime + 5*direction_time:
                    #    pitch = 10
                    else:
                        pitch = 0
                        cf.commander.send_setpoint(0, 0, 0, 0)
                        break

                    cf.commander.send_setpoint(0, 0, 0, 0)
                    #cf.commander.send_setpoint(roll, pitch, yawrate, thrust)
                    time.sleep(period_in_ms/1000)
                    print('\'time\': %d,%s,\'ref_gx\':%f,\'ref_gy\': %f, \'ref_gz\': %f #' % (timestamp, data, roll, pitch, yawrate))
                