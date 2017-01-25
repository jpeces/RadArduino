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
#define TRIGGER_PIN  7
#define ECHO_PIN     6
#define MAX_DISTANCE 50

/*Configuracion pines controlador motor DC */ 
#define IN1  12
#define IN2  11
#define IN3  10
#define IN4  9

/*Configuraciones pines LDR */
#define LDRin A0
 
/*Creacion del objeto de la clase NewPing*/
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

int uS; 
int light = 0;
int threshold = 820;
boolean calibrate = false;
boolean ok = false;

/*Parametro funcionamiento motor DC */
int steps_left=4095;
boolean Direction = true;
int Steps = 0;

int Paso [ 8 ][ 4 ] =
    {   {1, 0, 0, 0},
        {1, 1, 0, 0},
        {0, 1, 0, 0},
        {0, 1, 1, 0},
        {0, 0, 1, 0},
        {0, 0, 1, 1},
        {0, 0, 0, 1},
        {1, 0, 0, 1}
     };
 
void setup() {
  Serial.begin(9600);
  pinMode(IN1, OUTPUT); 
  pinMode(IN2, OUTPUT); 
  pinMode(IN3, OUTPUT); 
  pinMode(IN4, OUTPUT);

  pinMode(LDRin, INPUT);
}
 
void loop() {
  
  if(calibrate == false){
    light = analogRead(LDRin);
    Serial.println(light);
    if(light >= threshold)
    {
        calibrate = true;
        steps_left = 2048; 
    } else {
      //Serial.println("Calibrando");
      stepper();
      steps_left-- ;
      delay(2);
    }
  }

  if(calibrate == true)
  {
     if(ok == false){
       delay(1000);
       ok = true;
     }
//     light = analogRead(LDRin);
//     if(light >= threshold)
//     {
//        steps_left = 2048;
//     }
     Serial.println("Radar calibrado");
     stepper() ;    // Avanza un paso
     steps_left-- ;  // Un paso menos
     // Obtener medicion de tiempo de viaje del sonido y guardar en variable uS
     //uS = sonar.ping_median();

    // Imprimir la distancia medida a la consola serial
    //Serial.print("Distancia: ");
    
    // Calcular la distancia con base en una constante
    //Serial.print(uS / US_ROUNDTRIP_CM);
    
    //Serial.println("cm");

    
     //Espera un milisegundo entre paso y medicion
     delay (2);
  }
  
  if(steps_left == 0){
    delay(300);
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
     
    Steps = ( Steps + 7 ) % 7 ;
}


