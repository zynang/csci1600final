// Arduino Brain Library - Brain Serial Test

// Description: Grabs brain data from the serial RX pin and sends CSV out over the TX pin (Half duplex.)
// More info: https://github.com/kitschpatrol/Arduino-Brain-Library
// Author: Eric Mika, 2010 revised in 2014

#include <Brain.h>

// Set up the brain parser, pass it the hardware serial object you want to listen on.
Brain brain(Serial1);
String i = "off";
int timeSinceLastUpdate = 0;
String next = "";
String curr = "";
String prev = "";
int incrementer = 0;
const int buttonPin = 4; // the number of the pushbutton pin

// Variables will change: REVIEW!!!!!
int ledState = HIGH;        // the current state of the output pin
int buttonState;            // the current reading from the input pin
int lastButtonState = LOW;  // the previous reading from the input pin

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers

void setup() {
  // Enable internal pull-up resistor for buttonPin
  pinMode(buttonPin, INPUT_PULLUP);
  
  // Attach the interrupt to the button pin
  attachInterrupt(digitalPinToInterrupt(buttonPin), buttonInterrupt, RISING);

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
    Serial.print("b: ");
    Serial.println(brain.readCSV());
  }
  if (millis() - timeSinceLastUpdate > 8000){
    Serial.println("err1");
  }
}

void buttonInterrupt() {
  
    // Toggle between on and off
    if (i == "off"){
      i = "on";
    }
    else if (i == "on"){
      i = "off";
    }
    Serial.println("i: " + i);
}