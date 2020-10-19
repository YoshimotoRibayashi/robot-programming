#!/usr/bin/env python
# -*- coding: utf-8 -*-                                                                              

import rospy, actionlib, math
from tf import transformations
from move_base_msgs.msg import *

import sys, select, termios, tty

def getKey():
    if select.select([sys.stdin], [], [], 0) == ([sys.stdin], [], []):
        key = sys.stdin.read(1)
        return key
    return None

if __name__ == '__main__':
    settings = termios.tcgetattr(sys.stdin)
    tty.setcbreak(sys.stdin.fileno())
    
    try:
        rospy.init_node('send_goal', anonymous=True)
        client = actionlib.SimpleActionClient('move_base', MoveBaseAction)
        client.wait_for_server()

        for goal_pos in [[34, 32, 0], [34, 33, 0]]: #[41, 17, math.pi/2]]:
            goal = MoveBaseGoal()
            goal.target_pose.header.stamp = rospy.Time.now()
            goal.target_pose.header.frame_id = 'map'
            goal.target_pose.pose.position.x=goal_pos[0];
            goal.target_pose.pose.position.y=goal_pos[1];
            quaternion = transformations.quaternion_from_euler(0, 0, goal_pos[2])
            goal.target_pose.pose.orientation.x = quaternion[0]
            goal.target_pose.pose.orientation.y = quaternion[1]
            goal.target_pose.pose.orientation.z = quaternion[2]
            goal.target_pose.pose.orientation.w = quaternion[3]
            rospy.loginfo("send goal")
            rospy.loginfo(goal)
            client.send_goal(goal)
            rospy.loginfo("wait for goal ...")
            while True:
#            while ( client.get_state() != actionlib.GoalStatus.SUCCEEDED and
#                    client.get_state() != actionlib.GoalStatus.PREEMPTED ):
#            while ( client.get_state() == actionlib.GoalStatus.ACTIVE or
#                    client.get_state() == actionlib.GoalStatus.PENDING ) :
                rospy.loginfo("get_goal_status: ({}) PENDING ({}), ACTIVE ({}), PREEMPTED ({}), SUCCEEDED ({})".format(
                    client.get_state(), actionlib.GoalStatus.PENDING, actionlib.GoalStatus.ACTIVE,
                                        actionlib.GoalStatus.PREEMPTED, actionlib.GoalStatus.SUCCEEDED))
                if getKey() == 'c':
                    rospy.loginfo("cancel curernt goal")
                    client.cancel_goal()
                # rospy.sleep(0.5)
                ret = client.wait_for_result(rospy.Duration(0.5))
                rospy.loginfo("wait_for_result ... {}".format(ret))
                if ret:
                    break;

            rospy.loginfo("done")
            rospy.loginfo("get_goal_status: ({}) PENDING ({}), ACTIVE ({}), PREEMPTED ({}), SUCCEEDED ({})".format(
                client.get_state(), actionlib.GoalStatus.PENDING, actionlib.GoalStatus.ACTIVE,
                                    actionlib.GoalStatus.PREEMPTED, actionlib.GoalStatus.SUCCEEDED))
            if client.get_state() == actionlib.GoalStatus.SUCCEEDED:
                rospy.loginfo("goal reached")
    except rospy.ROSInterruptException: pass
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
