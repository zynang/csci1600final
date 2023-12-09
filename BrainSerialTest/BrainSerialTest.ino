// Arduino Brain Library - Brain Serial Test

// Description: Grabs brain data from the serial RX pin and sends CSV out over the TX pin (Half duplex.)
// More info: https://github.com/kitschpatrol/Arduino-Brain-Library
// Author: Eric Mika, 2010 revised in 2014

#include <Brain.h>

// Set up the brain parser, pass it the hardware serial object you want to listen on.
Brain brain(Serial1);
String m = "none";
const int buttonPin = 4;
int timeSinceLastUpdate = 0;
String next = "";
String curr = "";
String prev = "";
int incrementer = 0;


void setup() {
  // Enable internal pull-up resistor for buttonPin
  pinMode(buttonPin, INPUT_PULLUP);
  
  // Attach the interrupt to the button pin
  // attachInterrupt(digitalPinToInterrupt(buttonPin), buttonInterrupt, FALLING);

  // Start the hardware serial.
  Serial1.begin(9600);
  Serial.begin(9600);
  // Serial1.begin(38400);
  // Serial.begin(38400);
}

void loop() {
  // Expect packets about once per second.
  // The .readCSV() function returns a string (well, char*) listing the most recent brain data, in the following format:
  // "signal strength, attention, meditation, delta, theta, low alpha, high alpha, low beta, high beta, low gamma, high gamma"
  // Serial.println("test");
  if (brain.update()) {
    // Serial.println(brain.readErrors());
    timeSinceLastUpdate = millis();
    Serial.println(brain.readCSV());
    pinMode(buttonPin, INPUT); // Set the button pin as INPUT
    // delay(100);
  }
  if (millis() - timeSinceLastUpdate > 8000){
    // Serial.println(timeSinceLastUpdate);
    Serial.println("err1");
  }
  // else{
    
  //   delay(100);
  // }
  // delay(100);
   // TODO: but this error will be if headset is not even turned on
  // Serial.println(digitalRead(buttonPin));
  // Serial.println(m);

  // Check for serial input
  // if (Serial.available() > 0) {
  //   // Read the input
  //   String serialInput = Serial.readStringUntil('\n');
    
  //   // Check if it is a valid hexcode starting with '#'
  //   if (serialInput.startsWith("#") && isValidHexCode(serialInput.substring(1))) {
  //     m = serialInput.substring(1);
  //     Serial.println("Color set to: " + m);
  //   } else {
  //     Serial.println("Invalid color hexcode. Color not changed.");
  //   }
  // }

  // FROM PROCESSING
  //  int val = analogRead(13);
  //  val = map(val, 0, 300, 0, 255);
  //      Serial.println("something else:");

  //   Serial.println(val);
  //   // Serial.println("hello");

  //   delay(50);
}

// void buttonInterrupt() {
//   // Reset the variable m to "none" when the button is pressed
//   m = "none";
//   Serial.println("Color reset to: none");
// }


// Function to check if a string is a valid hexcode
bool isValidHexCode(String hex) {
  for (int i = 0; i < hex.length(); i++) {
    char c = hex.charAt(i);
    if (!isHexadecimalDigit(c)) {
      return false;
    }
  }
  return true;
}

