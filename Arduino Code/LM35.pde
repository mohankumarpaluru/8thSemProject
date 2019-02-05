float temp;
int tempPin = A0;

void setup()

{

Serial.begin(9600);

}

void loop()

{

temp = analogRead(tempPin);

temp = temp * 0.48828125;

Serial.print("TEMPRATURE = ");

Serial.print(temp);

Serial.print(" Degree Celsius");

Serial.println();

delay(1000);

}
