#! /usr/bin/env python

import os
import rospy
from geometry_msgs.msg import PoseStamped
from diagnostic_msgs.msg import KeyValue
from rosplan_knowledge_msgs.srv import *
from rosplan_knowledge_msgs.msg import *
from mongodb_store.message_store import MessageStoreProxy
from visualization_msgs.msg import MarkerArray
from visualization_msgs.msg import Marker
import numpy as np

# Add instance to knowledge base
def add_instance(type, name):
    global query_kb, update_kb

    instances = query_kb(type).instances
    if (name not in instances):
        try:
            new = KnowledgeItem()
            new.knowledge_type = KnowledgeItem.INSTANCE
            new.instance_type = type
            new.instance_name = name
            resp = update_kb(KnowledgeUpdateServiceRequest.ADD_KNOWLEDGE, new)
            print('Adding instance [%s] to the knowledge base...'%name)
        except rospy.ServiceException, e:
            print("Service call failed: %s"%e)
    else:
        print('Instance [%s] already in the knowledge base...'%name)

# Add facts to knowledge base
def add_fact(name, values):
    global query_kb, update_kb

    try:
        new = KnowledgeItem()
        new.knowledge_type = KnowledgeItem.FACT
        new.attribute_name = name
        for key, value in values.iteritems():
            new.values.append(KeyValue(key, value))
        resp = update_kb(KnowledgeUpdateServiceRequest.ADD_KNOWLEDGE, new)
        print('Adding fact [%s] to the knowledge base...'%name)
    except rospy.ServiceException, e:
        print("Service call failed: %s"%e)

# Add goal to knowledge base
def add_goal(name, values):
    global query_kb, update_kb

    try:
        new = KnowledgeItem()
        new.knowledge_type = KnowledgeItem.FACT
        new.attribute_name = name
        for key, value in values.iteritems():
            new.values.append(KeyValue(key, value))
        resp = update_kb(KnowledgeUpdateServiceRequest.ADD_GOAL, new)
        print('Adding goal [%s] to the knowledge base...'%name)
    except rospy.ServiceException, e:
        print("Service call failed: %s"%e)

# Load waypoints from file
def load_waypoints(filename):
    waypoint_array = dict()
    for line in open(filename, 'r'):
        wp_id = line.split('[')[0]
        wp_position_string = line.split('[')[1].split(']')[0]
        waypoint_array[wp_id] = map(float, wp_position_string.split(','))

    return waypoint_array

def add_waypoint(name, pos, connecting_distance):
    global update_map

    try:
        newpose = PoseStamped()
        newpose.header.frame_id = 'map'
        newpose.pose.position.x = pos[0]
        newpose.pose.position.y = pos[1]
        newpose.pose.position.z = pos[2]
        newpose.pose.orientation.x = 0.0;
        newpose.pose.orientation.y = 0.0;
        newpose.pose.orientation.z = 0.0;
        newpose.pose.orientation.w = 1.0;
        occupancy_threshold = 2;

        resp = update_map(name, newpose, connecting_distance,occupancy_threshold)
        print('Adding waypoint [%s] to the knowledge base...'%name)
    except rospy.ServiceException, e:
        print("Service call failed: %s"%e)


def start_node():
    global query_kb, update_kb, update_map
    global location_marker_pub, marker_id

    rospy.init_node('add_knowledge')

    # Wait for services to start
    print('Waiting for [get_current_instances] services to start...')
    rospy.wait_for_service('/kcl_rosplan/get_current_instances')
    print('Waiting for [update_knowledge_base] services to start...')
    rospy.wait_for_service('/kcl_rosplan/update_knowledge_base')
    print('Waiting for [add_waypoint] services to start...')
    rospy.wait_for_service('/kcl_rosplan/roadmap_server/add_waypoint')

    # Subscribe to services
    query_kb = rospy.ServiceProxy('/kcl_rosplan/get_current_instances', GetInstanceService)
    update_kb = rospy.ServiceProxy('/kcl_rosplan/update_knowledge_base', KnowledgeUpdateService)
    update_map = rospy.ServiceProxy('/kcl_rosplan/roadmap_server/add_waypoint', AddWaypoint)

    location_marker_pub = rospy.Publisher("/kcl_rosplan/viz/waypoints", MarkerArray, queue_size = 1)

    # Add helicopter
    add_instance('helicopter', 'heli1')

    # Add turtlebot
    add_instance('turtlebot', 'tb1')

    # Add crate types
    add_instance('crate-type','food')
    add_instance('crate-type', 'medicine')

    # Add crates
    add_instance('crate','food_crate1')
    add_instance('crate','food_crate2')

    # Add persons
    add_instance( 'person','person1')
    add_instance( 'person','person2')

    # Add avoid areas
    #add_instance( 'area','q1')
    #add_instance( 'area','q2')
    #add_instance('area','q3')
    #add_instance('area','q4')


    # Add locations

    xmin = -1.8;
    xmax = 2.5;
    ymin = -5.0;
    ymax = 2;
    npointsx = 7*2;
    npointsy = 7*2;
    stepx = (xmax - xmin)/(npointsx - 1);
    stepy = (ymax - ymin)/(npointsy - 1);
    maxstep = max(stepx,stepy);
    connecting_distance = 1.42 * maxstep;

    # Add initial position
    add_waypoint('linit', [1.4, -2.4, 0], connecting_distance)

    # Add initial position
    add_waypoint('g1', [0, 0, 0], connecting_distance)

    z = 0;
    j = 0;
    for x in np.linspace(xmin,xmax,npointsx):
        i = 0;
        for y in np.linspace(ymin,ymax,npointsy):
            pos = [x, y, z]
            name = 'l_' + str(i) + '_' + str(j)
            add_waypoint(name, pos, connecting_distance)
            #add_fact('associated_area', {'a': 'q1', 'l1':name})

            i = i + 1;
        j = j+1



    #add_fact('person-at', {'pers': 'person1', 'loc':'l_4_5'})
    #add_fact('person-at', {'pers': 'person2', 'loc':'l_6_4'})

    add_fact('crate-is-type', {'crate_': 'food_crate1', 'c_type':'food'})
    add_fact('crate-is-type', {'crate_': 'food_crate2', 'c_type':'food'})


    #add_fact('connected-area', {'a1': 'q1', 'a2': 'q2'})
    #add_fact('connected-area', {'a1': 'q1', 'a2': 'q3'})
    #add_fact('connected-area', {'a1': 'q1', 'a2': 'q4'})

    #add_fact('connected-area', {'a1': 'q2', 'a2': 'q1'})
    #add_fact('connected-area', {'a1': 'q2', 'a2': 'q3'})
    #add_fact('connected-area', {'a1': 'q2', 'a2': 'q4'})

    #add_fact('connected-area', {'a1': 'q3', 'a2': 'q1'})
    #add_fact('connected-area', {'a1': 'q3', 'a2': 'q2'})
    #add_fact('connected-area', {'a1': 'q3', 'a2': 'q4'})

    #add_fact('connected-area', {'a1': 'q4', 'a2': 'q1'})
    #add_fact('connected-area', {'a1': 'q4', 'a2': 'q2'})
    #add_fact('connected-area', {'a1': 'q4', 'a2': 'q3'})

    #add_fact('area_available', {'a': 'q2'})
    #add_fact('area_available', {'a': 'q3'})
    #add_fact('area_available', {'a': 'q4'})

    # Helicopter Init
    add_fact('helicopter-available', {'heli': 'heli1'})
    #add_fact('helicopter-at', {'heli': 'heli1','loc': 'l46'})
    #add_fact('helicopter-in-area', {'heli': 'heli1','a': 'q1'})
    add_fact('helicopter-empty', {'heli': 'heli1'})

	# Turtlebot Init
    add_fact('turtlebot-available', {'tb': 'tb1'})
    add_fact('turtlebot-at', {'tb': 'tb1','loc': 'linit'})
    #add_fact('turtlebot-in-area', {'tb': 'tb1','a': 'q1'})

    # Other Init
    add_fact('person-needs', {'p': 'person1', 'ct':'food'})
    add_fact('person-needs', {'p': 'person2', 'ct':'food'})

	#Crate Init
    #add_fact('crate-at', {'c': 'food_crate1','loc': 'l01'})
    #add_fact('crate-at', {'c': 'food_crate2','loc': 'l10'})

    add_fact('crate-free-standing', {'c': 'food_crate1'})
    add_fact('crate-free-standing', {'c': 'food_crate2'})

	#(crate-is-type food_crate2 food)

    #add_fact('robot_at', {'v':tb_name, 'wp':'wp_0_0'})

    # Add waypoints



    # Add goals

    #add_goal('visited', {'wp':'wp_0_0'})
    #add_goal('visited', {'wp':'wp_0_1'})

    #add_goal('person-has', {'p':'person1', 'ct':'food'})
    #add_goal('person-has', {'p':'person2', 'ct':'food'})

    add_goal('turtlebot-at', {'tb': 'tb1','loc': 'g1'})

    #(person-has person1 food)
	#(person-has person2 food)
    rospy.sleep(2)

if __name__ == '__main__':
    start_node()
