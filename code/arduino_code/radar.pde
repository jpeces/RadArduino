//shift

class linea
{
  float x, y, alpha;
 linea(float _x, float _y, float _alpha)
 {
   x = _x;
   y = _y;
   alpha = _alpha;
 }
 
 void draw()
 {
   fill(0,128,0,alpha);
   line(0,0,x,y);
 }
}


int MAXX=1366;
int MAXY=768;
int j = 576;
int gira = 1;

void setup()
{
  size(1366,768);
  background(0); 
}

void draw()
{
 background(0); 

 stroke(0,255,0); 
 
 translate(MAXX/2,MAXY/2);
 
 ellipse(0,0, 1, 1);
 ellipse(0,0, MAXY -10, MAXY-10);
 ellipse(0,0, MAXY/2, MAXY/2);
 
 line(0,(MAXY-10)/2,0,-((MAXY-10)/2));
 line((MAXY-10)/2,0,(-(MAXY-10)/2),0);

 noFill();

 stroke(0,0,128);
 
 if(gira == 1)
 {
 pintar(j);
 j++;
 }else if(gira == -1)
 {
  pintar(j);
  j--;
 }
 
 if(j == 1152 || j == -1152)
 {
 j=0;
 gira = gira*(-1);
 }
}

 void pintar(int i)
 {
  stroke(0,0,128);
  line(0,0,(MAXY-10)/2*cos((PI/(4*144))*i+PI/2),(MAXY-10)/2*sin((PI/(4*144))*i+PI/2)); 
 }