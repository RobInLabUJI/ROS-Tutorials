import rospy
from nav_msgs.msg import Odometry
import matplotlib.pyplot as plt
from IPython import display

import os, time

prev_time = None

def callback(msg):
    global prev_time
    current_time = time.time()
    if not prev_time or \
        current_time - prev_time > 0.2:
            prev_time = current_time
            os.system('xwd -display :99 -root | xwdtopnm 2> /dev/null | pnmtopng > frame.png ')
            frame = plt.imread('frame.png')
            fig = plt.figure(num=1,figsize=(10,10),clear=True)
            plt.imshow(frame);
            plt.axis('off');
            display.display(plt.gcf())
            display.clear_output(wait=True)
                    
def plot():
    rospy.init_node('stage_display', anonymous=True)
    rospy.Subscriber('/robot_0/odom', Odometry, callback)
    rospy.spin()