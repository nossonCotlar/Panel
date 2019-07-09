const int amount = 4;

char val; // Data received from the serial port
byte input[2];
int ledPin = 11; // Set the pin to digital I/O 11
int pins[] = {11, 10, 9, 6};
float bright[amount] = {0};

void setup() {

  for (int i = 0; i < amount; i++) {
    pinMode(pins[i], OUTPUT); // Set pin as OUTPUT
  }

  Serial.begin(9600); // Start serial communication at 9600 bps
}

void loop() {
  while (Serial.available()) { // If data is available to read,
    Serial.readBytes(input, 2); // read it and store it in val
  }
  //Serial.write(input[1]);
  if (input[1] == 'H') { // If H was received
    bright[input[0]] = 1023; // turn the LED on
  }

  for (int i = 0; i < amount; i++) {
    bright[i] = lerp(bright[i], 0, .07f);
  }





  for (int i = 0; i < amount; i++) {
    analogWrite(pins[i], bright[i]);
  }



  delay(1); // Wait 100 milliseconds for next reading

}

float lerp(float a, float b, float f)
{
  return (a * (1.0f - f)) + (b * f);
}
