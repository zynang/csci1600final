// Arduino Brain Library - Brain Serial Test

// Description: Grabs brain data from the serial RX pin and sends CSV out over the TX pin (Half duplex.)
// More info: https://github.com/kitschpatrol/Arduino-Brain-Library
// Author: Eric Mika, 2010 revised in 2014

#include <Brain.h>
#include <WiFi101.h>
#include <WiFiUdp.h>

// Set up the brain parser, pass it the hardware serial object you want to listen on.
Brain brain(Serial1);
String i = "off";
String err;
int timeSinceLastUpdate = 0;
//String next = "";
//String curr = "";
//String prev = "";
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


// WIFI
/* UDP setup for NTP (world clock) */
//unsigned int localPort = 2390;      // local port to listen for UDP packets
//IPAddress timeServer(129, 6, 15, 28); // time.nist.gov NTP server
//const int NTP_PACKET_SIZE = 48; // NTP time stamp is in the first 48 bytes of the message
//byte packetBuffer[ NTP_PACKET_SIZE]; //buffer to hold incoming and outgoing packets
// A UDP instance to let us send and receive packets over UDP
WiFiUDP Udp;
WiFiSSLClient client;
boolean interruptRandomWifi = false;

char httpGETbuf[200]; // to form HTTP GET request
//unsigned long reqTime; // time of NTP request
//unsigned long secsSince1900; // NTP response
void setup() {
  // Enable internal pull-up resistor for buttonPin
  pinMode(buttonPin, INPUT_PULLUP);
  
  // Attach the interrupt to the button pin
  attachInterrupt(digitalPinToInterrupt(buttonPin), buttonInterrupt, RISING);

  // Start the hardware serial.
  Serial1.begin(9600);
  Serial.begin(9600);
  while(!Serial); // remove when running with headset
  setupWiFi();
  // Clear and enable WDT
  NVIC_DisableIRQ(WDT_IRQn);
  NVIC_ClearPendingIRQ(WDT_IRQn);
  NVIC_SetPriority(WDT_IRQn, 0);
  NVIC_EnableIRQ(WDT_IRQn);

  //Configure and enable WDT GCLK:
  GCLK->GENDIV.reg = GCLK_GENDIV_DIV(4) | GCLK_GENDIV_ID(5);
  while(GCLK->STATUS.bit.SYNCBUSY);
  GCLK->GENCTRL.reg = GCLK_GENCTRL_DIVSEL | GCLK_GENCTRL_ID(0x5) | GCLK_GENCTRL_GENEN | GCLK_GENCTRL_SRC(0x03);
  while(GCLK->STATUS.bit.SYNCBUSY);
  GCLK->CLKCTRL.reg = GCLK_CLKCTRL_GEN(0x5) | GCLK_CLKCTRL_CLKEN | GCLK_CLKCTRL_ID(0x03);

  WDT->CONFIG.reg = WDT_CONFIG_PER(0x9); 
  WDT->EWCTRL.reg = WDT_EWCTRL_EWOFFSET(0x8);
  WDT->CTRL.reg = WDT_CTRL_ENABLE;

   // Enable early warning interrupts on WDT:
  WDT->INTENSET.reg = WDT_INTENSET_EW;
  // uncomment to run unit tests
  // testButtonInterrupt();
}

void loop() {
  // Expect packets about once per second.
  // The .readCSV() function returns a string (well, char*) listing the most recent brain data, in the following format:
  // "signal strength, attention, meditation, delta, theta, low alpha, high alpha, low beta, high beta, low gamma, high gamma"
  // Serial.println("test");

  // uncomment to run unit tests
  // testWatchDogTimer();
  // testNoData();

  if (brain.update()) {
    timeSinceLastUpdate = millis();
    String csvVals = brain.readCSV();
    if (interruptRandomWifi == true){
      if (readWebpage()) {
        sendHTTPReq();
      }
    }
    Serial.print("b: ");
    Serial.println(brain.readCSV());
  }
  if (millis() - timeSinceLastUpdate > 5000){
    err = "err1";
    Serial.println("err1");
  }

  // Pet the watchdog
  if (!WDT->STATUS.bit.SYNCBUSY) { 
  WDT->CLEAR.reg = WDT_CLEAR_CLEAR(0xA5); 
  }
}

void buttonInterrupt() {
    // Toggle between on and off
    // When interrupt, turning to on, want to send HTTP request, read in the last byte which is the number then pass that and parse it
    if (i == "off"){
      i = "on";
      interruptRandomWifi = true;
    }
    else if (i == "on"){
      i = "off";
      interruptRandomWifi = false;
    }
    Serial.println("i: " + i);
}

void WDT_Handler() {
  //Clear interrupt register flag
  WDT->INTFLAG.bit.EW = 1;
  Serial.println("WATCHDOG RESET ABOUT TO HAPPEN BE CAREFUL :D");
}

/*
 * Connect to WiFi network, get NTP time, and connect to random.org
 */
void setupWiFi() {
  char ssid[] = "Brown-Guest";  // network SSID (name)
  char pass[] = ""; // for networks that require a password
  int status = WL_IDLE_STATUS;  // the WiFi radio's status

  // attempt to connect to WiFi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid); // WiFi.begin(ssid, pass) for password
    delay(5000);
  }
  Serial.println("Connected!");

  if (connectToWebpage()) {
    Serial.println("fetched webpage");
  } else {
    Serial.println("ERROR: failed to fetch webpage");
    Serial.println("Are SSL certificates installed?");
    while(true); // 
  }
  Serial.println();
}

/*
 * Send SSL connection request to server
 * Return true if successful
 */
bool connectToWebpage() {
  if (client.connectSSL("www.random.org", 443)) {
    sendHTTPReq();
    return true;
  } else {
    Serial.println("Failed to fetch webpage");
    return false;
  }
}

/*
 * Print response to HTTP request
 * return true if response was received
 */
bool readWebpage() {
    // Check for bytes to read
  int len = client.available();
  int counter = 0;
  if (len == 0){
    return false;
  }

  while (client.available()) {
    counter+=1;
    if (counter == len-1){
      char num = (char) client.read();
      Serial.print("O: ");
      Serial.println(num);
    }
    client.read();
  }
  return true;
}


void sendHTTPReq() {
  // LAB STEP 4e: change the second argument to be (the current time since Jan 1, 1990 in seconds) / 3
  sprintf(httpGETbuf, "GET /integers/?num=1&min=0&max=1&col=1&base=10&format=plain&rnd=id.%lu HTTP/1.1", millis());
  client.println(httpGETbuf);
  client.println("Host: www.random.org");
  client.println();
}
