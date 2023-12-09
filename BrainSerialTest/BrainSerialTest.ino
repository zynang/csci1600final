// Arduino Brain Library - Brain Serial Test

// Description: Grabs brain data from the serial RX pin and sends CSV out over the TX pin (Half duplex.)
// More info: https://github.com/kitschpatrol/Arduino-Brain-Library
// Author: Eric Mika, 2010 revised in 2014

#include <Brain.h>
#include <SPI.h>
#include <WiFi101.h>
#include <WiFiUdp.h>
#include <ArduinoHttpClient.h>

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

// WIFI THINGS
unsigned int localport = 2390;
IPAddress timeServer(76, 76, 21, 22); // got from ping msv-web-jmaffas-projects.vercel.app 
const int PACKET_SIZE = 64; // MAY NEED TO ADJUST, just reading from ping
byte packetBuffer[PACKET_SIZE]; // MAY NEED TO ADJUST
WiFiUDP Udp;
WiFiClient wifiClient;
WiFiSSLClient client;
String serverAddress = "https://msv-web.vercel.app/";
int serverPort = 443; 


char httpGETbuf[200];
// WiFiSSLClient client;
HttpClient httpClient = HttpClient(wifiClient, serverAddress, serverPort);


char httpPOSTbuf[200]; //

unsigned long reqTime; // time of request?
unsigned long res; // response?

void setup() {
  // Enable internal pull-up resistor for buttonPin
  pinMode(buttonPin, INPUT_PULLUP);
  
  // Attach the interrupt to the button pin
  attachInterrupt(digitalPinToInterrupt(buttonPin), buttonInterrupt, RISING);

  // Start the hardware serial.
  Serial1.begin(9600);
  Serial.begin(9600);
  setupWiFi();
  // Serial1.begin(38400);
  // Serial.begin(38400);
  // Clear and enable WDT
  // NVIC_DisableIRQ(WDT_IRQn);
  // NVIC_ClearPendingIRQ(WDT_IRQn);
  // NVIC_SetPriority(WDT_IRQn, 0);
  // NVIC_EnableIRQ(WDT_IRQn);

  // //Configure and enable WDT GCLK:
  // GCLK->GENDIV.reg = GCLK_GENDIV_DIV(4) | GCLK_GENDIV_ID(5);
  // while(GCLK->STATUS.bit.SYNCBUSY);
  // GCLK->GENCTRL.reg = GCLK_GENCTRL_DIVSEL | GCLK_GENCTRL_ID(0x5) | GCLK_GENCTRL_GENEN | GCLK_GENCTRL_SRC(0x03);
  // while(GCLK->STATUS.bit.SYNCBUSY);
  // GCLK->CLKCTRL.reg = GCLK_CLKCTRL_GEN(0x5) | GCLK_CLKCTRL_CLKEN | GCLK_CLKCTRL_ID(0x03);

  // WDT->CONFIG.reg = WDT_CONFIG_PER(0x9); 
  // WDT->EWCTRL.reg = WDT_EWCTRL_EWOFFSET(0x8);
  // WDT->CTRL.reg = WDT_CTRL_ENABLE;

  //  // Enable early warning interrupts on WDT:
  // WDT->INTENSET.reg = WDT_INTENSET_EW;
}

void loop() {
  // REMOVE AFTER TESTING IS DONE WITH WIFI
//  String mock = "b: 0,52,51,284017,128944,41894,28099,10124,23677,1752,1289";
//  sendPostRequest(mock);
//  Serial.println("sending");
//  delay(5000);

  if (readWebpage()) {
      Serial.println("Something was received using HTTP!");
      /*
       * LAB STEP 4e:
       * Check if sBuf is not empty
       * Send bytes via UART
       */
      
      // Send a new request
      delay(2000); // remove me!
      sendHTTPReq();
    }

    // Connection ended / no more bytes to read
    if (!client.connected()) {
      delay(500);
      // Try to reconnect
      connectToWebpage();
    }

  // Expect packets about once per second.
  // The .readCSV() function returns a string (well, char*) listing the most recent brain data, in the following format:
  // "signal strength, attention, meditation, delta, theta, low alpha, high alpha, low beta, high beta, low gamma, high gamma"
  // Serial.println("test");
  // if (brain.update()) {
    
  //   // Serial.println(brain.readErrors());
  //   timeSinceLastUpdate = millis();
  //   String start = "b: ";
  //   String read = brain.readCSV();
  //   String out = start.concat(read);
  //   // Serial.print("b: ");
  //   Serial.println(out);
  //   // SEND POST REQ TOO
  // }
  if (brain.update()) {
    // Serial.println(brain.readErrors());
    timeSinceLastUpdate = millis();
    String start = "b: ";
    String read = String(brain.readCSV()); // Convert unsigned char to String
    String out = start + read; // Use + operator instead of concat
    // Serial.print("b: ");
    // sendPostRequest(out);
    Serial.println(out);
    // SEND POST REQ TOO
  }

  if (millis() - timeSinceLastUpdate > 8000){
    Serial.println("err1");
  }

  // Pet the watchdog
  // if (!WDT->STATUS.bit.SYNCBUSY) { 
  // WDT->CLEAR.reg = WDT_CLEAR_CLEAR(0xA5); 
  // }
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

// void WDT_Handler() {
//   //Clear interrupt register flag
//   WDT->INTFLAG.bit.EW = 1;
//   Serial.println("WATCHDOG RESET ABOUT TO HAPPEN BE CAREFUL :D");
// }

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

  // connectToNTP();

   if (connectToWebpage()) {
     Serial.println("fetched webpage");
   } else {
     Serial.println("ERROR: failed to fetch webpage");
     Serial.println("Are SSL certificates installed?");
     while(true); // 
   }
  Serial.println();
}
// bool connectToWebpage() {
//   if (client.connectSSL("https://msv-web.vercel.app", 443)) {
//     // sendHTTPReq();
//     return true;
//   } else {
//     Serial.println("Failed to fetch webpage");
//     return false;
//   }
// }
bool connectToWebpage() {
//  if (client.connect("msv-web-jmaffas-projects.vercel.app", 443)) {
//  }
//  if (client.connectSSL("https://msv-web-jmaffas-projects.vercel.app/", 443)) {
  if (client.connectSSL("www.random.org", 443)) {

    sendHTTPReq();
    return true;
  } else {
    Serial.println("Failed to fetch webpage");
    Serial.print("Error code: ");
//    Serial.println(client.connectError());
    return false;
  }
}
void sendHTTPReq() {
  // LAB STEP 4e: change the second argument to be (the current time since Jan 1, 1990 in seconds) / 3
  sprintf(httpGETbuf, "GET /integers/?num=1&min=1&max=3&col=1&base=10&format=plain&rnd=id.%lu HTTP/1.1", millis());
  client.println(httpGETbuf);
  client.println("Host: www.random.org");
  client.println();
}
void sendPostRequest(String data) {
  // Make the request
  String dataHeader = "{\"data\":";
  String postBody = dataHeader + data +"}";
  httpClient.post("/api/post", "application/json", postBody);
//  httpClient.post("/api/post", "application/x-www-form-urlencoded", data);
  

  // Get the response from the server
  int statusCode = httpClient.responseStatusCode();
  String response = httpClient.responseBody();

  // Print the response
  Serial.println("HTTP Status Code: " + String(statusCode));
  Serial.println("Response: " + response);
}

bool readWebpage() {
    // Check for bytes to read
  int len = client.available();
  if (len == 0){
    return false;
  }

  while (client.available()) {
    Serial.print((char) client.read());
  }
  Serial.println();
  return true;

  /*
   * LAB STEP 3b: change above code to only print RED, GREEN, or BLUE as it is read
   * LAB STEP 3c: change above code to send 'r', 'g', or 'b' via Serial1
   * LAB STEP 4e: change above code to put 'r', 'b', or 'g' in sBuf for sending on UART
   */
}
