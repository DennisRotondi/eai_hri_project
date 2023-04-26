tilix -w /home/dennis/Desktop/arm_2023/arm_gazebo/docker/ -e ./run.bash nvidia
tilix -w /home/dennis/Desktop/arm_2023/arm_gazebo/docker/ -e bash tmux.bash
xterm -e python3 -m http.server &
xterm -e roslaunch rosbridge_server rosbridge_websocket.launch &
matlab .
