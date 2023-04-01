#include "robokt/Speechtext.h"
#include "robokt/State.h"
#include "geometry_msgs/PoseStamped.h"
#include "ros/ros.h"
#include "std_msgs/String.h"
#include <tf/tf.h>
#include <tf2_msgs/TFMessage.h>
#include <tf2_ros/transform_listener.h>
#include <vector>
#include <fstream>

using namespace std;

enum class STATE {AVAILABLE = 0, WORKING = 1};

// globals
ros::Publisher pub_text;
ros::Subscriber sub_text;

STATE state;

void logger(const std_msgs::String& text){
    pub_text.publish(text);
}

void log_string(const string& msg){
  std_msgs::String text;
  text.data = msg;
  logger(text);
}

void text_cb(const std_msgs::String &msg){
  if (state == STATE::AVAILABLE){
      log_string("hello world");
      cout << msg.data << endl;
  }
  else
    log_string("Robot: I'm sorry but I'm busy right now, please try again later");
}

int main(int argc, char **argv) {
  state = STATE::AVAILABLE;
  ros::init(argc, argv, "robokt");
  ros::NodeHandle n;
  ros::Rate loop_rate(10);
  pub_text= n.advertise<std_msgs::String>("/logger_web", 1000);
  sub_text = n.subscribe("/text_speech", 1000, text_cb);
  ros::spin();
}