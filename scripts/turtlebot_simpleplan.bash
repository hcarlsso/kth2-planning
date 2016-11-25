#!/bin/bash

# Randomly generate waypoints. We should replace this with /kcl_rosplan/roadmap_server/add_waypoint
#rosservice call /kcl_rosplan/roadmap_server/create_prm "{nr_waypoints: 5, min_distance: 0.3, casting_distance: 5.0, connecting_distance: 8.0, occupancy_threshold: 10, total_attempts: 10}";

rosservice call /kcl_rosplan/roadmap_server/add_waypoint "id: 'wp0'
waypoint:
  header:
    seq: 0
    stamp: 0
    frame_id: 'map'
  pose:
    position:
      x: 0.0
      y: 0.0
      z: 0.0
    orientation:
      x: 0.0
      y: 0.0
      z: 0.0
      w: 1.0
connecting_distance: 3.4
occupancy_threshold: 2";

rosservice call /kcl_rosplan/roadmap_server/add_waypoint "id: 'wp1'
waypoint:
  header:
    seq: 0
    stamp: 0
    frame_id: 'map'
  pose:
    position:
      x: 2.0
      y: 1.0
      z: 0.0
    orientation:
      x: 0.0
      y: 0.0
      z: 0.0
      w: 1.0
connecting_distance: 3.4
occupancy_threshold: 2";



#  Add traveltimes etc from original domain

# Add a turtlebot
rosservice call /kcl_rosplan/update_knowledge_base "update_type: 0
knowledge:
  knowledge_type: 0
  instance_type: 'robot'
  instance_name: 'kenny'
  attribute_name: ''
  function_value: 0.0";

# Initial waypoint of the turtlebot
rosservice call /kcl_rosplan/update_knowledge_base "update_type: 0
knowledge:
  knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'robot_at'
  values:
  - {key: 'v', value: 'kenny'}
  - {key: 'wp', value: 'wp0'}
  function_value: 0.0";

# Add goals
for i in 0 1
do
rosservice call /kcl_rosplan/update_knowledge_base "update_type: 1
knowledge:
  knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'visited'
  values:
  - {key: 'wp', value: 'wp$i'}
  function_value: 0.0"
done;

# Call planning server
rosservice call /kcl_rosplan/planning_server;
