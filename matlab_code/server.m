addpath(genpath(pwd));
savepath
% IMPORTANT: Change IP address according to your env !!!!!!!  
rosIP = "192.168.1.57";  %"192.168.1.57"; 10.10.247.106 %
init_ros;
load_models;

global rgbImgSub logger_pub network rgbImgPub jointPub tftree status depthImgSub text_speech

status = "available";
tftree = rostf;
depthImgSub = rossubscriber("/camera/depth/image_raw","sensor_msgs/Image","DataFormat","struct");
rgbImgSub= rossubscriber("/camera/rgb/image_raw","sensor_msgs/Image","DataFormat","struct");
rgbImgPub= rospublisher("/camera/rgb/image_raw_3","sensor_msgs/CompressedImage","DataFormat","object");
network = load("detector.mat").detector;
logger_pub = rospublisher("/logger_web","std_msgs/String","DataFormat","struct");
jointPub = rospublisher("/cartesian_impedance_example_controller/equilibrium_pose");
text_speech_pub = rospublisher("/text_speech","std_msgs/String","DataFormat","struct");
text_speech = rossubscriber("/text_speech",@text_speech_call);
pause(1);