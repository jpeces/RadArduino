# RadArduino
This project is a sonar (Sound Navigator And Ranging) that we have implemented with a Arduino Leonardo and we have depicted in Processing 3.

Its works in the following way:

A stepper motor rotate 360º sideways, and when reaches the end, change the direction and rotate another 360º. The reason why the motor doesn’t move is because is pinned to the base. While stepper motor is rotating, the ultrasonic sensor collects information constantly. This information is sent to Processing through the serial port.

The program that we have created in Processing have two ways for representing the data collected. The first one is with lines and the second draws circles at the distance that ultrasonic sensor has detected the object. The representation mode it can be changed if we press key “space bar”. When we change the representation mode, the radar is calibrates automatically with the encoder installed.

At the starting, the radar doesn't do anything until the Processing code runs and send the signal to start. That way Arduino and Processing initiate at the same time.

For more information and learn how to build it you can visit the [instructable page](https://www.instructables.com/id/RadArduino-Radar-Made-With-Arduino-Leonardo-and-Pr/):
