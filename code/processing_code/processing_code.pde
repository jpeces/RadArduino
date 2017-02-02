/*
====================================================================================================

  Project: RadArduino.
    Radar based in Arduino Leonardo. Arduino controls an stepper motor through a controller (ULN2003A).
    An encoder has been implemented with a LED and a fotoresistor. This encoder calibrates the system.
    The GUI has been created with Processing 3.
    
  Makers: Borja Gordillo Ramajo, Javier Peces Chillarón, Pablo Cazorla Martínez.
  
  Subject: Electrónica Creativa.
  
  Universidad de Málaga.
=====================================================================================================
*/

import processing.serial.*;
Serial serialPort;
float data;
String[] ports;

int state;  // Program state variable
int mode;   // Mode variable

boolean startFlag; // Print lines flag

int resetC = 0;

float dataNew;
int dMax;
float xNew;
float yNew;

float[] points = new float [512]; // Distances capture by the sensor HC-SR04

int j= 256;
int motion = 1;
int w;


/* Setup */

void setup()
{
  fullScreen();
  noCursor();
  background(0); 
  mode = 1;
  startFlag = true;

  dMax = 50; // Sensor range, the same value of MAX_DISTANCE in arduino code
  
  w = ((height-10)/2)-4;
  
  ports = Serial.list();
  print("Available COM ports:\n" + "  ");
  println(ports);
  println();
  
  if(ports.length != 0)
  {
    serialPort = new Serial(this, Serial.list()[0], 57600);
    serialPort.bufferUntil('\n');
  } 
  
  serialPort.write(254); // send start code 254 to Arduino
}


/* Loop */

void draw()
{
  strokeWeight(1);
  
  showMenu();
 
  translate(width/2,height/2);
   
  showRadarShape();

  if(startFlag){
    show(j); //<>//
    startFlag = false;
    
    if(mode == 1) modeTracking(data, j);
    else if(mode == -1) mode2D(data, j);
    
    showRadarShape();
    
    if(j == 533 || j == -533){
      j=0;
      motion = motion*(-1);
    }
    
    if(resetC == 1){
      background(0);
      resetC = 0;
    }
  }
}


/* Auxiliar functions */

void show(int p)
{
  int i = 0;
  stroke(0,128,0);
  strokeWeight(4);                      // set the thickness of the lines
  if (motion == 1 && p < 512) {         // if going left to right
    for (  ; i <= 20; i++) {            // draw 20 lines with fading colour each 1 degree further round than the last
      if((PI/(256))*p+PI/2 - radians(i) > PI/2)
      {
        if(i==0)
        stroke(0,255,0);
        else
        stroke(0, 120-(6*i), 0);        // set the stroke colour (Red, Green, Blue) base it on the the value of i
        
        line(0, 0, cos((PI/(256))*p+PI/2 - radians(i))*w, sin((PI/(256))*p+PI/2 - radians(i))*w); // line(start x, start y, end x, end y) 
      }
    }
    j++;
  } else if(motion == -1 && p > -512){  // if going right to left
      for (; i <= 20; i++) {            // draw 20 lines with fading colour
      if((PI/(256))*p+PI/2 + radians((i)) < PI/2)
      {
        if(i==0)
        stroke(0,255, 0);
        else
        stroke(0, 120-(6*i) ,0);        // using standard RGB values, each between 0 and 255
        
        line(0, 0, cos((PI/(256))*p+PI/2 + radians((i)))*w, sin((PI/(256))*p+PI/2 + radians(i))*w);    
      }
    }
    j--;
    
  } else if(motion == 1 && p >= 512)
  {
    strokeWeight(10);
    stroke(0,0,0);                    
    line(0, 0, cos((PI/(256))*512+PI/2 - radians(532-p))*w, sin((PI/(256))*512+PI/2 - radians(532-p))*w);   // line(start x, start y, end x, end y) 
   j++;
  } else if(motion == -1 && p <= -512)
  {
    strokeWeight(10);
    stroke(0, 0,0);             
    line(0, 0, cos((PI/(256))*512+PI/2 + radians(532+p))*w, sin((PI/(256))*512+PI/2 + radians(532+p))*w);   // line(start x, start y, end x, end y) 
   j--;
  }
 }

void showMenu() // Show the change mode menu on top left
{
  fill(0);
  stroke(0,255,0);
  rect(width*0.03, height*0.03, 235, 147, 12);
  textSize(16);
  fill(255);
  text("MODE:",width*0.05, height*0.07);
  text("Tracking",width*0.085, height*0.115);
  text("2D model",width*0.085, height*0.155);
  textSize(14);
  text("*Press espace to change mode",width*0.04, height*0.20);
  
  if(mode == 1){
     noFill();
     rect(width*0.08, height*0.09, 85, 27, 12);
  
  }else if(mode == -1){
     noFill();
     rect(width*0.08, height*0.13, 90, 27, 12);
  } 
}

void showRadarShape()  // show the radar circles
{
  fill(0,0,0);
  noFill();
 
  strokeWeight(1);
  stroke(0,130,0); 
  ellipse(0,0,height-10,height-10);
  ellipse(0,0, height/2, height/2);
  line(0,(height-10)/2,0,-((height-10)/2));
  line((height-10)/2,0,(-(height-10)/2),0);
  
  strokeWeight(1);
  stroke(0,255,0);
}

void modeTracking(float distance, int p)  // Points mode 
{
  dataNew = map(distance,0,dMax,0,w); //<>//
  noStroke();
  
  if (motion == 1 && p < 512) {
      points[p]= dataNew;
      
  }else if(motion == -1 && p > -512){
      points[511+p] = dataNew;  
  }
  strokeWeight(1);
  for(int i = 0; i<512; i++)
  {
    xNew = cos((PI/(256))*i+PI/2)*points[i];
    yNew = sin((PI/(256))*i+PI/2)*points[i];
    if(xNew != 0 || yNew !=0)
    {
      fill(0,170,0);
      ellipse(xNew, yNew, 15, 15);
    }  
  }
}

void mode2D(float distance, int p) // Lines mode
{
  dataNew = map(distance,0,dMax,0,w);
  stroke(0,170,0);
  
  if (motion == 1 && p < 512) {
      points[p]= dataNew;
      
  }else if(motion == -1 && p > -512){
      points[511+p] = dataNew;  
  }
  strokeWeight(5);
  for(int i = 0; i<512; i++)
  {
    beginShape();
    vertex(0,0);
    xNew = cos((PI/(256))*i+PI/2)*points[i];
    yNew = sin((PI/(256))*i+PI/2)*points[i];
    vertex(xNew,yNew);   
    endShape(); 
  }
}

void keyPressed() // Capture when we press the espace bar
{
  if(keyCode == 32){
     mode *= -1;
     resetCanvas();
     serialPort.write(255); // Send recalibration bit
     startFlag = false;
  }
}

void resetCanvas() 
{
  for(int i=0; i<512; i++){
    points[i] = 0;
  }
  background(0);
  startFlag = false;
  resetC = 1;
  j = 256;
  motion = 1;
}

void serialEvent(Serial myport) // Capture the data at the serial port where the arduino is connected
{
  data = float(myport.readStringUntil('\n'));
  
  if(data < 254){
    startFlag = true;
  }
}