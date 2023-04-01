# Progetto EAI-HRI 2023

#### use robokt

Clone this repository on your own machine, inside the ws initialize the workspace with catkin_init, build with catkin_make and source devel/setup.bash (to have the custom messages created), then launch rosbridge:

```sh
sudo apt-get install ros-<rosdistro>-rosbridge-server
```
```sh
roslaunch rosbridge_server rosbridge_websocket.launch 
```

This allows you to create the webserver on which to circulate ROS messages, it's as if the client becomes a node.

Still source in the ws folder (if you are using another terminal instance) and then launch:

```sh 
rosrun robokt robokt
```

At this point, you need to serve the html page that will act as the client interface, this can be done by using the main cloned folder:

```sh 
python3 -m http.server
```
It may be necessary:
```sh 
python3 -m pip install websocket
python3 -m pip install simple_http_server
```

The page will be made available on port 8000, machine address obtainable with ifconfig. e.g., 192.168.1.69:8000

## Extra

#### Setup static IP for the Ubuntu18 virtual machine on VirtualBox, network attached to Bridged Adapter
It might be useful to assign a static IP to the robot to always reach it at the same address, this was done by modifying the network settings of the machine setting them to manual and in addresses inserting:

- Address: <ip machine eg. 192.168.1.69>
- Netmask: 255.255.255.0
- Gateway: <can be attained with | grep default>
- DNS: 8.8.8.8, 192.168.1.1

ref: http://wiki.ros.org/rosbridge_suite

ref: http://wiki.ros.org/roslibjs
