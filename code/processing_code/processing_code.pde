import processing.serial.*;
Serial serialPort;
String data;
String[] ports;

int state;  // Program state variable

int j = 256;
int lim = 1;

void setup()
{
  fullScreen();
  background(0); 
  state = 0;
  
  ports = Serial.list();
  print("Available COM ports:\n" + "  ");
  println(ports);
  println();
  
  if(ports.length != 0)
  {
    serialPort = new Serial(this, Serial.list()[0], 57600);
    serialPort.bufferUntil('\n');
  }
  
}

void draw()
{
  strokeWeight(1);
  //background(0); 
   
  stroke(0,255,0); 
   
  translate(width/2,height/2); //<>//
   
  fill(0,0,0,9);
   
  ellipse(0,0,height-10,height-10);
  ellipse(0,0, height/2, height/2);
  line(0,(height-10)/2,0,-((height-10)/2));
  line((height-10)/2,0,(-(height-10)/2),0);
  
  noFill(); //<>//
  
  stroke(0,0,128);
   
  if(lim == 1){
    show(j);
    j++;
  }else if(lim == -1){
    show(j);
    j--;
  }
   //<>//
  strokeWeight(1);
  stroke(0,255,0);
  
  if(j == 512 || j == -512){
    j=0;
    lim = lim*(-1);
  }
}

void show(int i)
{
  stroke(0,0,128);
  strokeWeight(4);
  line(0,0,(height-10)/2*cos((PI/(256))*i+PI/2),(height-10)/2*sin((PI/(256))*i+PI/2)); 
 }
 
void serialEvent(Serial myport) 
{
  data = myport.readStringUntil('\n');    
}