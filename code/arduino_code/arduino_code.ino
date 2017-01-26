/*
====================================================================================================

  Proyecto: RadArduino.
    Implementacion de un radar basado en arduino leonardo. Utiliza un motor paso a paso (28BYJ-48)
    con su controlador (ULN2003A) para hacer girar 360º un sonar. Girará 360º en un sentido y luego
    360º en el contrario.
    La representación gráfica se hará con Processing.
    
  Autores: Borja Gordillo Ramajo, Javier Peces Chillarón, Pablo Cazorla Martínez.
  
  Asignatura: Electrónica Creativa.
  
  Universidad de Málaga.
=====================================================================================================
*/


#include <NewPing.h>
 
/* Configuracion de los pines del sensor HC-SR04 */
#define TRIGGER_PIN  7 //Azul
#define ECHO_PIN     6
#define MAX_DISTANCE 50

/*Configuracion pines controlador motor DC */ 
#define IN1  12
#define IN2  11
#define IN3  10
#define IN4  9

/*Configuraciones pines LDR */
#define LDRin A0

boolean letsGo = false;
 
/*Creacion del objeto de la clase NewPing*/
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

int uS; 
int light = 0;
int threshold = 870;
boolean calibrate = false;
boolean ok = false;
int sendData = 8;

int i = 0;

/*Parametro funcionamiento motor DC */
int steps_left=4095;
boolean Direction = true;
int Steps = 0;

int Paso [ 8 ][ 4 ] =     //Configuracion a medios pasos
    {   {1, 0, 0, 0},
        {1, 1, 0, 0},
        {0, 1, 0, 0},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 1},
        {0, 0, 0, 1},
        {1, 0, 0, 1}
     };

//int Paso [ 4 ][ 4 ] =   //Configuracion normal
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
        steps_left = 2048;
     }
     stepper() ;    // Avanza un paso
     --sendData;
     steps_left-- ;  // Un paso menos

     if(sendData == 0){
       //Gets a travel time measurement
       uS = sonar.ping();
       // Estimates distances using a constant
       Serial.println(uS / US_ROUNDTRIP_CM);
       sendData = 8;
     }
    
     //Wait for 1 ms
     delay (3);
  }
  
  if(steps_left == 0){
    delay(5);
    Direction=!Direction;
    steps_left=4095;
  }
}

void stepper()            //Avanza un paso
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



