#!/usr/bin/env python
# -*- coding: utf-8 -*-
import math
import rospy
import actionlib
from trajectory_msgs.msg import JointTrajectory
from trajectory_msgs.msg import JointTrajectoryPoint
from control_msgs.msg import FollowJointTrajectoryAction, FollowJointTrajectoryGoal

from opencv_apps.msg import RotatedRectStamped
from image_view2.msg import ImageMarker2
from geometry_msgs.msg import Point
from geometry_msgs.msg import Twist

rect = RotatedRectStamped() ## 大域変数として定義

def cb(msg):
    global rect ## 大域変数の利用を宣言
    ## 画像処理の結果 (msg) を大域変数 rect に登録
    rect = msg

if __name__ == '__main__':
    try:
        rospy.init_node('client')
        rospy.Subscriber('/camshift/track_box', RotatedRectStamped, cb)
        pub = rospy.Publisher('/cmd_vel', Twist, queue_size=10)
        rate = rospy.Rate(100) # changed from 10
        while not rospy.is_shutdown(): ## 無限ループに入る
            cmd_vel=Twist()
            # turn to object by bang-bang control
            #print(rect)
            print(rect.rect.center.x)
            if rect.rect.size.width == 0:
                cmd_vel.angular.z = 1.0 #search
            else:
                if rect.rect.center.x > 360:
                    cmd_vel.angular.z = -1.0 # turn right
                elif rect.rect.center.x < 280:
                    cmd_vel.angular.z = 1.0 # turn left

            pub.publish(cmd_vel)
            rate.sleep()
    except rospy.ROSInterruptException: pass # エラーハンドリング
