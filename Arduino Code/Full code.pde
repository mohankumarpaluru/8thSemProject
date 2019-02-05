#include "dht.h"
#define dht_apin A0  // humidity pin
#include "SX1272.h"
#include <SPI.h>

int e;
char message1 [60];
int ldr;
int ntc; 
int sensor_pin = A1; // soil pin
int output_value ;	// soil output 
float temp;       
int tempPin = A3;    // temp pin 
int sensorPin = A4; 	// mq2 pin
int DOPin = 2;
int sensorValue = 0;
int ledPin =13;
int nRainIn = A5;
int nRainDigitalIn = 2;
int nRainVal;
boolean bIsRaining = false;
String strRaining;



void setup() {

   Serial.begin(9600);

   Serial.println("Reading From the Sensors ...");
   
   pinMode(DOPin, INPUT);
   
   pinMode(ledPin, OUTPUT);
   
   pinMode(2,INPUT);
   
   // Power ON the module
  sx1272.ON();
  
  // Set transmission mode and print the result
  e = sx1272.setMode(4);
  Serial.println(F("Setting Mode: state "));
  Serial.println(e, DEC);
  
  // Select frequency channel
  e = sx1272.setChannel(CH_12_868);
  Serial.println(F("Setting Channel: state "));
  Serial.println(e, DEC);
  
  // Select output power (Max, High or Low)
  e = sx1272.setPower('H');
  Serial.println(F("Setting Power: state "));
  Serial.println(e, DEC);
  
  // Set the node address and print the result
  e = sx1272.setNodeAddress(2);
  Serial.println(F("Setting node address: state "));
  Serial.println(e, DEC);
  
  // Print a success message
  Serial.println(F("SX1272 successfully configured"));

   delay(2000);

   }

void loop() {
	
	DHT.read11(dht_apin);   // Humidity sensor cose 
    
    Serial.print("Current humidity = ");
	
    Serial.print(DHT.humidity);
	
    Serial.print("%  ");
	
    Serial.print("temperature = ");
	
    Serial.print(DHT.temperature); 
	
    Serial.println("C  ");   

	output_value= analogRead(sensor_pin);   // soil moisture sensor code 

	output_value = map(output_value,550,0,0,100);

	Serial.print("Mositure : ");

	Serial.print(output_value);
	
	Serial.println("%");
   
	temp = analogRead(tempPin);  // temperature sensor code 

	temp = temp * 0.48828125;

	Serial.print("TEMPRATURE = ");

	Serial.print(temp);

	Serial.print(" Degree Celsius");

	Serial.println();

	delay(1000);
	
	sensorValue = analogRead(sensorPin);  // NO sensor code 
	
	Serial.print("Analog Output = ");
	
	Serial.println(sensorValue);
	// turn the ledPin on if triggered
	
	if (digitalRead(DOPin) ==HIGH) {
    
	digitalWrite(ledPin, LOW);
    
	Serial.println("Digital Output = OFF");
	
	} else {
    
	digitalWrite(ledPin, HIGH);
    
	Serial.println("Digital Output = ON");  
	}
	
	nRainVal = analogRead(nRainIn);   // rain guauge code 
	bIsRaining = !(digitalRead(nRainDigitalIn));
	if(bIsRaining){
    strRaining = "YES";
	}
	else{
    strRaining = "NO";
	}
  
	Serial.print("Raining?: ");
	Serial.print(strRaining);  
	Serial.print("\t Moisture Level: ");
	Serial.println(nRainVal);
  
	delay(200);
	
	ldr = analogRead(1);   // Lora Transmitter Code 
	
	get_temp();
	
	sprintf(message1,"LDR value: %i \r\nNTC value: %i\r\n",ldr,ntc);
	
	e = sx1272.sendPacketTimeout(3, message1); 
	
	Serial.println(message1);
	
	Serial.print(F("Packet sent, state "));
	
	Serial.println(e, DEC); 

	delay(5000);  


   }