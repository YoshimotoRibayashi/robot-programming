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

def send_joint_position_actionlib():
    # rosnode の初期化
    # rospy.init_node('send_joint_position')
    # トピック名,メッセージ型を使って ActionLib client を定義
    client = actionlib.SimpleActionClient('/fullbody_controller/follow_joint_trajectory',
    FollowJointTrajectoryAction)
    client.wait_for_server() # ActionLib のサーバと通信が接続されることを確認
    # ActionLib client の goal を指定
    # http://wiki.ros.org/actionlib_tutorials/Tutorials の
    # Writing a Simple Action Client (Python) を参照
    # __TOPIC_PREFIX__Action で actionlib.SimpleActionClient を初期化
    # ゴールオブジェクトは __TOPIC_PREFIX__Goal を使って生成
    goal = FollowJointTrajectoryGoal()
    goal.trajectory = JointTrajectory()
    goal.trajectory.header.stamp = rospy.Time.now()
    goal.trajectory.joint_names = ['arm_joint1', 'arm_joint2', 'arm_joint3',
    'arm_joint4', 'arm_joint5', 'arm_joint6']
    for i in range(5):
        point = JointTrajectoryPoint()
        point.positions = [math.pi/2, 0, math.pi/4*(i%2), 0, math.pi/2, math.pi/2]
        point.time_from_start = rospy.Duration(1.0+i)
        goal.trajectory.points.append(point)
    ## 目標姿勢をゴールとして送信
    client.send_goal(goal)
    rospy.loginfo("wait for goal ...")
    client.wait_for_result() # ロボットの動作が終わるまで待つ.
    rospy.loginfo("done")

rect = RotatedRectStamped() ## 大域変数として定義

def cb(msg):
    global rect ## 大域変数の利用を宣言
    ## 画像処理の結果 (msg) を大域変数 rect に登録
    rect = msg

if __name__ == '__main__':
    try:
        # rospy.init_node('client')
        rospy.init_node('send_joint_position')
        rospy.Subscriber('/camshift/track_box', RotatedRectStamped, cb)
        # pub = rospy.Publisher('/cmd_vel', Twist)
        rate = rospy.Rate(10)
        while not rospy.is_shutdown(): ## 無限ループに入る
            print(rect.rect.size.width)
            if rect.rect.size.width > 100:
                send_joint_position_actionlib()
            rate.sleep()
    except rospy.ROSInterruptException: pass # エラーハンドリング
