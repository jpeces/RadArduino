import processing.serial.*;
Serial serialPort;
String data;
String[] ports;

int state;  // Program state variable

int j = 256;
int motion = 1;
int w;

void setup()
{
  fullScreen();
  background(0); 
  state = 0;
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
  
}

void draw()
{
  strokeWeight(1);
  //background(0); 
 
  translate(width/2,height/2); //<>//
   
  fill(0,0,0);
  noFill(); //<>//
  
  stroke(0,0,128); 
  show(j);
  strokeWeight(1);
  stroke(0,255,0); 
  ellipse(0,0,height-10,height-10);
  ellipse(0,0, height/2, height/2);
  line(0,(height-10)/2,0,-((height-10)/2));
  line((height-10)/2,0,(-(height-10)/2),0);
   //<>//
  strokeWeight(1);
  stroke(0,255,0);
  
  if(j == 512 || j == -512){
    j=0;
    motion = motion*(-1);
  }
}

void show(int p)
{
  stroke(0,0,128);
  strokeWeight(1);
  line(0,0, w*cos((PI/(256))*p+PI/2), sin((PI/(256))*p+PI/2)*w); 
  strokeWeight(4);                      // set the thickness of the lines
  if (motion == 1) {                    // if going left to right
    for (int i = 0; i <= 20; i++) {     // draw 20 lines with fading colour each 1 degree further round than the last
      stroke(0, 0,(10*i));              // set the stroke colour (Red, Green, Blue) base it on the the value of i
      line(0, 0, cos((PI/(256))*p+PI/2 + radians(i))*w, sin((PI/(256))*p+PI/2 + radians((i)))*w); // line(start x, start y, end x, end y) 
    }
    j++;
  } else {                              // if going right to left
    for (int i = 20; i >= 0; i--) {     // draw 20 lines with fading colour
      stroke(0, 0, 200-(10*i));         // using standard RGB values, each between 0 and 255
      line(0, 0, cos((PI/(256))*p+PI/2 + radians((i)))*w, sin((PI/(256))*p+PI/2 + radians(i))*w);
    }
    j--;
  }
 }
 
void serialEvent(Serial myport) 
{
  data = myport.readStringUntil('\n');    
}