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


#include <NewPing.h> //NewPing library allows an easy programming of HC-SR04 sensor.
 
/* Pins configuration (HC-SR04 sensor) */
#define TRIGGER_PIN  7 //Blue-Orange
#define ECHO_PIN     6 //Orange-Green
#define MAX_DISTANCE 50

/*Pins configuration (stepper motor controller) */ 
#define IN1  12
#define IN2  11
#define IN3  10
#define IN4  9

/*Pins configuration (LDR) */
#define LDRin A0

boolean letsGo = false;
 
/*NewPing object created
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

int uS; 
int light = 0;
int threshold = 870;
boolean calibrate = false;
boolean ok = false;
int sendData = 8;

int i = 0;

/*Stepper motor parameters */
int steps_left=4095;
boolean Direction = true;
int Steps = 0;

int Paso [ 8 ][ 4 ] =     //Half steps (Soft movement)
    {   {1, 0, 0, 0},
        {1, 1, 0, 0},
        {0, 1, 0, 0},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 1},
        {0, 0, 0, 1},
        {1, 0, 0, 1}
     };

//int Paso [ 4 ][ 4 ] =   //Complete steps (faster and more torque)
//    {   {1, 1, 0, 0},
//        {0, 1, 1, 0},
//        {0, 0, 1, 1},
//        {1, 0, 0, 1},
//     };

  
 
void setup() {
  Serial.begin(57600);
  pinMode(IN1, OUTPUT); 
  pinMode(IN2, OUTPUT); 
  pinMode(IN3, OUTPUT); 
  pinMode(IN4, OUTPUT);

  pinMode(LDRin, INPUT);
}
 
void loop() {
  
  while(!letsGo)
  {
    i = Serial.read();
    if(i == 254)
    {
      letsGo = true;
      i = 0;
    }
  }
  
  i = Serial.read();
  if(i == 255)
  {
    calibrate = false;
    if(steps_left < 100)
    {
      Direction = !Direction;
    }
    i = 0;
  }
  
  if(calibrate == false){
    light = analogRead(LDRin);
    if(light >= threshold)
    {
        calibrate = true;
        Direction = true;
        steps_left = 2048; 
    } else {
      stepper();
      steps_left-- ;
      delay(1);
    }
  }

  if(calibrate == true)
  {
     if(ok == false){
       delay(1000);
       ok = true;
     }
     light = analogRead(LDRin);
     if(light >= threshold)
     {
        steps_left = 2048; //Auto-calibration when HC-SR04 reachs the middle point (where LDR is)
     }
     stepper() ;    // Go one step.
     --sendData;
     steps_left-- ;  // One step more gone.

     if(sendData == 0){
      
       //Gets a travel time measurement
       uS = sonar.ping();
       // Estimates distances using a constant
       Serial.println(uS / US_ROUNDTRIP_CM);
       sendData = 8;
       
     }
    
     //Wait for 3 ms every step.
     delay (3);
  }
  
  if(steps_left == 0){
    delay(5); //Wait 5 ms when one round is completed
    Direction=!Direction;
    steps_left=4095;
  }
}

void stepper()            //It function increase a half step.
{
  digitalWrite( IN1, Paso[Steps][ 0] );
  digitalWrite( IN2, Paso[Steps][ 1] );
  digitalWrite( IN3, Paso[Steps][ 2] );
  digitalWrite( IN4, Paso[Steps][ 3] );
  
  SetDirection();
}

void SetDirection()
{
    if(Direction)
        Steps++;
    else 
        Steps--; 
     
    Steps = ( Steps + 8 ) % 8 ;
}



