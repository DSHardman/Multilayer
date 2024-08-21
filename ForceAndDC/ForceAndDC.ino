#include "HX711.h"

#define DOUT  8
#define CLK  9

HX711 scale;

int sensorPin1 = A5;
int sensorPin2 = A4;
int sensorPin3 = A3;

int sensorValue1 = 0;
int sensorValue2 = 0;
int sensorValue3 = 0;


float calibration_factor = 4116;
float current_reading;

void setup() {
  Serial.begin(115200);
  scale.begin(DOUT, CLK);
  scale.set_scale();
  scale.tare();
}

float runningAverage(float M) {
  #define LM_SIZE 3
  static float LM[LM_SIZE];
  static byte index = 0;
  static float sum = 0;
  static byte count = 0;

  sum -= LM[index];
  LM[index] = M;
  sum += LM[index];
  index++;
  index = index % LM_SIZE;
  if (count < LM_SIZE) count++;

  return sum / count;
}

void loop() {

  scale.set_scale(calibration_factor);
  current_reading = (scale.get_units());
  sensorValue1 = analogRead(sensorPin1);
  sensorValue2 = analogRead(sensorPin2);
  sensorValue3 = analogRead(sensorPin3);

  Serial.print(0.00981*runningAverage(current_reading), 4); // Print in N
  Serial.print(" ");

  Serial.print(sensorValue1);
  Serial.print(" ");
  Serial.print(sensorValue2);
  Serial.print(" ");
  Serial.println(sensorValue3);
  delay(500);

}
