#!/usr/bin/env python
# coding: UTF-8
import rospy, actionlib
import sys, select, termios, tty

'''
def getKey():
    if select.select([sys.stdin], [], [], 0) == ([sys.stdin], [], []):
        key = sys.stdin.read(1)
        return key
    return None
'''
def getKey():
    tty.setraw(sys.stdin.fileno())
    select.select([sys.stdin], [], [], 0)
    key = sys.stdin.read(1)
    termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
    return key

from move_base_msgs.msg import *
if __name__ == '__main__':
    settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    try:
        rospy.init_node('send_goal', anonymous=True)
        client = actionlib.SimpleActionClient('move_base', MoveBaseAction)
        client.wait_for_server() # ActionLibのサーバと通信が接続されることを確認
        goal = MoveBaseGoal()
        goal.target_pose.header.stamp = rospy.Time.now()
        goal.target_pose.header.frame_id = 'map'
        goal.target_pose.pose.position.x=34;
        goal.target_pose.pose.position.y=32;
        goal.target_pose.pose.orientation.w = 1
        rospy.loginfo("send goal")
        rospy.loginfo(goal)
        client.send_goal(goal) # 目標位置姿勢をgoalとして送信
        rospy.loginfo("wait for goal ...")
        print("C-c to exit")
        # rret = client.wait_for_result() # ロボットが目標位置姿勢に到達するまで待つ
        while(1):
            key=getKey()
            if key=='\x03':
                client.cancel_goal()
                break
        rospy.loginfo("done")
    except rospy.ROSInterruptException: pass
    #finally:
        #termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
 
