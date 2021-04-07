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
Simple example that connects to the first Crazyflie found, logs the Stabilizer
and prints it to the console. After 10s the application disconnects and exits.
This example utilizes the SyncCrazyflie and SyncLogger classes.
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

    #for i in available:
    #    print(i[0])

    if len(available) == 0:
        print('No Crazyflies found, cannot run example')
    else:
        lg_stab = LogConfig(name='Stabilizer', period_in_ms=10)

        lg_stab.add_variable('stateEstimate.x', 'float')
        lg_stab.add_variable('stateEstimate.y', 'float')
        lg_stab.add_variable('stateEstimate.z', 'float')

        lg_stab.add_variable('pm.batteryLevel', 'uint8_t')

        lg_stab.add_variable('stabilizer.roll', 'float')
        lg_stab.add_variable('stabilizer.pitch', 'float')
        lg_stab.add_variable('stabilizer.yaw', 'float')
        i = 0
        
        #print("antes")
        cf = Crazyflie(rw_cache='./cache')
        #print("antes 2")
        with SyncCrazyflie(available[0][0], cf=cf) as scf:
            
            #print("Meio")
            # Note: it is possible to add more than one log config using an
            # array.
            #with SyncLogger(scf, [lg_stab, other_conf]) as logger:
            cf.param.set_value('kalman.resetEstimation', '1')
            time.sleep(0.1)
            cf.param.set_value('kalman.resetEstimation', '0')
            time.sleep(2)
            
            
            with SyncLogger(scf, lg_stab) as logger:
                #print("depois")
                startTime = time.time()
                step_size = 0.5
                safe_height = 0.105
                descent_speed = 0.005
                tempo_descida = (((step_size-safe_height)/descent_speed)*10)/1000
                zerou = 0
                tempo_assentamento = 18

                #cf.param.set_value('kalman.stateX', '0')
                #cf.param.set_value('kalman.stateY', '0')

                for log_entry in logger:
                    timestamp = log_entry[0]
                    data = log_entry[1]
                    #logconf_name = log_entry[2]
                    nowTime = time.time()
                    if nowTime < startTime + tempo_assentamento:
                        vx = 0
                        vy = 0
                        yawrate = 90
                        zdistance = step_size  
                    elif nowTime < startTime + tempo_assentamento + tempo_descida:
                        zdistance -= descent_speed
                    elif nowTime < startTime + tempo_assentamento + tempo_descida + 1:
                        zdistance = safe_height
                    else:
                        cf.commander.send_stop_setpoint()
                        break
                    cf.commander.send_setpoint(vx,vy,zdistance,yawrate)
                    #cf.commander.send_hover_setpoint(vx, vy, yawrate, zdistance) #vx, vy, yawrate, zdistance

                    # if(i<5):
                    #     i = i + 1
                    # else:
                    #     print('%d,%s' % (timestamp, data))
                    print('\'tempo\': %d,%s,\'ref_vx\':%f,\'ref_vy\': %f, \'ref_z\': %f, \'ref_yawrate\': %f #' % (timestamp, data, vx, vy, zdistance, yawrate))
                    
                    # if time.time() > endTime:
                    #     break