# Preperations
cd ~/Documents/ros_planning/
source devel/setup.bash
catkin_make

# Terminal 1
cd ~/Documents/ros_planning/
source devel/setup.bash
sudo service mongodb stop
roslaunch kth2_planning turtlebot.launch

# Terminal 2
cd ~/Documents/ros_planning/
source devel/setup.bash
rqt --standalone rosplan_rqt.dispatcher.ROSPlanDispatcher

# Terminal 3
cd ~/Documents/ros_planning/
source devel/setup.bash
python src/kth2_planning/scripts/add_knowledge.py


# Start planning (generate problem and execute)
rosservice call /kcl_rosplan/planning_server;

#bash src/kth2_planning/scripts/turtlebot_simpleplan.bash



Password: wasp2016


