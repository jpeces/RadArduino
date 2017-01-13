#include <NewPing.h>
 
/* Configuracion de los pines del sensor HC-SR04 */
#define TRIGGER_PIN  12
#define ECHO_PIN     11
#define MAX_DISTANCE 50
 
/*Creacion del objeto de la clase NewPing*/
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

int uS; 
 
void setup() {
  Serial.begin(9600);
}
 
void loop() {
  // Esperar 1 segundo entre mediciones
  delay(1);
  // Obtener medicion de tiempo de viaje del sonido y guardar en variable uS
  uS = sonar.ping_median();
  // Imprimir la distancia medida a la consola serial
  Serial.print("Distancia: ");
  // Calcular la distancia con base en una constante
  Serial.print(uS / US_ROUNDTRIP_CM);
  Serial.println("cm");
}


