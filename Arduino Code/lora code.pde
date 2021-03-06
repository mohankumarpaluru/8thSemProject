/*  
 *  LoRa 868 / 915MHz SX1272 Module
 *  
 *  Copyright (C) Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or 
 *  (at your option) any later version. 
 *  
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License 
 *  along with this program.  If not, see http://www.gnu.org/licenses/. 
 *  
 *  Version:           1.0
 *  Design:            David Gascón 
 *  Implementation:    Victor Boria & Luis Miguel Marti
 */
 
// Include the SX1272 and SPI library: 
#include "SX1272.h"
#include <SPI.h>

int e;
char message1 [60];
int ldr;
int ntc;

void setup()
{
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  
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
}

void loop(void)
{
  
  ldr = analogRead(1);
  get_temp();
  sprintf(message1,"LDR value: %i \r\nNTC value: %i\r\n",ldr,ntc);
  e = sx1272.sendPacketTimeout(3, message1); 
  Serial.println(message1);
  Serial.print(F("Packet sent, state "));
  Serial.println(e, DEC); 

  delay(5000);  

}

void get_temp() {
  ntc = analogRead(0) * 5 / 1024.0;
  ntc = ntc - 0.5;
  ntc = ntc / 0.01;
}
