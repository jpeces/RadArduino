import processing.serial.*;
Serial serialPort;
String data;
String[] ports;

int state;  // Program state variable

int j = 400;
int motion = 1;
int w;

void setup()
{
  fullScreen();
  background(0); 
  state = 0;
  w = ((height-10)/2)-4;
  
  /*ports = Serial.list();
  print("Available COM ports:\n" + "  ");
  println(ports);
  println();
  
  if(ports.length != 0)
  {
    serialPort = new Serial(this, Serial.list()[0], 57600);
    serialPort.bufferUntil('\n');
  }*/
  
}

void draw()
{
  strokeWeight(1);
  //background(0); 
  showMenu();
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
  
  if(j == 533 || j == -533){
    j=0;
    motion = motion*(-1);
  }
}

void show(int p)
{
  int i = 0;
  stroke(0,0,128);
  strokeWeight(4);                      // set the thickness of the lines
  if (motion == 1 && p < 512) {                    // if going left to right
    for (  ; i <= 20; i++) {     // draw 20 lines with fading colour each 1 degree further round than the last
      if((PI/(256))*p+PI/2 - radians(i) > PI/2)
      {
        if(i==0)
        stroke(0,0,255);
        else
        stroke(0, 0,120-(6*i));              // set the stroke colour (Red, Green, Blue) base it on the the value of i
        
        line(0, 0, cos((PI/(256))*p+PI/2 - radians(i))*w, sin((PI/(256))*p+PI/2 - radians(i))*w); // line(start x, start y, end x, end y) 
      }
    }
    j++;
  } else if(motion == -1 && p > -512){      // if going right to left
    for (; i <= 20; i++) {     // draw 20 lines with fading colour
      if((PI/(256))*p+PI/2 + radians((i)) < PI/2)
      {
        if(i==0)
        stroke(0,0,255);
        else
        stroke(0, 0,120-(6*i));         // using standard RGB values, each between 0 and 255
        
        line(0, 0, cos((PI/(256))*p+PI/2 + radians((i)))*w, sin((PI/(256))*p+PI/2 + radians(i))*w);
        
      }
    }
    j--;
  } else if(motion == 1 && p >= 512)
  {
    strokeWeight(10);
    stroke(0, 0,0);              // set the stroke colour (Red, Green, Blue) base it on the the value of i
    line(0, 0, cos((PI/(256))*512+PI/2 - radians(532-p))*w, sin((PI/(256))*512+PI/2 - radians(532-p))*w); // line(start x, start y, end x, end y) 
   j++;
  } else if(motion == -1 && p <= -512)
  {
    strokeWeight(10);
    stroke(0, 0,0);              // set the stroke colour (Red, Green, Blue) base it on the the value of i
    line(0, 0, cos((PI/(256))*512+PI/2 + radians(532+p))*w, sin((PI/(256))*512+PI/2 + radians(532+p))*w); // line(start x, start y, end x, end y) 
   j--;
  }
 }

void showMenu()
{
  fill(0);
  stroke(0,255,0);
  rect(width*0.03, height*0.03, 250, 170, 12);
  textSize(16);
  fill(255);
  text("HOLA",width*0.04, height*0.07);
}

void keyPressed() 
{
  if(keyCode == 32){
     state = 0;
  }

}

void serialEvent(Serial myport) 
{
  data = myport.readStringUntil('\n');    
}