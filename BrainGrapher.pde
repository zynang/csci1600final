// Main controller / model file for the the Processing Brain Grapher.

// See README.markdown for more info.
// See http://frontiernerds.com/brain-hack for a tutorial on getting started with the Arduino Brain Library and this Processing Brain Grapher.

// Latest source code is on https://github.com/kitschpatrol/Processing-Brain-Grapher
// Created by Eric Mika in Fall 2010, updates Spring 2012 and again in early 2014.

import processing.serial.*;

Serial serial;

Channel[] channels = new Channel[11];
Graph graph;
Circle circle;
Rect rect;
int disp_x=1440;
int disp_y=960;


int packetCount = 0;
int globalMax = 0;
String scaleMode;
int headsetOn = 0;
int currColor;
int nextColor;
int timeSinceLastColorChange = 0;
int currR;
int currG;
int currB;
boolean nextColorReached = false;
void setup() {
  // Set up window
  size(1440,960);
  //size(disp_x, disp_y);
  
  setupHelper();
  // Comment in for Zyn
  //serial = new Serial(this, "COM6", 9600);    
  //serial.bufferUntil(10);
  
  // Comment in for Joe
  //for (int i = 0; i < Serial.list().length; i++) {
  //  println("[" + i + "] " + Serial.list()[i]);
  //}
  serial = new Serial(this, Serial.list()[5], 9600);
  serial.bufferUntil(10);
  // Set up the graph
  rect = new Rect();
}

void draw() {
  serialEvent(serial);
  // Keep track of global maxima
  if (scaleMode == "Global" && (channels.length > 3)) {
    for (int i = 3; i < channels.length; i++) {
      if (channels[i].maxValue > globalMax) globalMax = channels[i].maxValue;
    }
  }
  if (millis() - timeSinceLastColorChange >= 2000 && nextColorReached == true){
    currColor = nextColor;
    nextColor = color(int(random(255)),int(random(255)),int(random(255)));
    nextColorReached = false;
    timeSinceLastColorChange = millis();
  }
  // Clear the background
  background(255);
  if (headsetOn==1){
    if (channels[0].getLatestPoint().value == 200){
      //delay(500);
      String err_msg1 = "Headset is on...";
      String err_msg2 = "But no connection detected!";
      String err_msg3 = ":-(";
  
      //println(red(nextColor));
      if (currR > red(nextColor)){
        currR-=1;
      }
      else if (currR < red(nextColor)){
        currR+=1;
      }
      if (currG > green(nextColor)){
        currG-=1;
      }
      else if (currG < green(nextColor)){
        currG+=1;
      }
      if (currB > blue(nextColor)){
        currB-=1;
      }
      else if (currB < blue(nextColor)){
        currB+=1;
      }
      fill(currR,currG,currB);
      //println(currR, currG, currB);
      //println(red(nextColor) + "; " + green(nextColor) + "; " + blue(nextColor));
      if (currR == red(nextColor) && currG == green(nextColor) && currB == blue(nextColor)){
        nextColorReached = true;
      }
      //fill(lerpedColor); // Text color
      textSize(70);
      text(err_msg1, 225, 400);
      text(err_msg2, 275, 500);
      text(err_msg3, 325, 600);
    }
    else{
      println("drawing rect");
      rect.draw();
    }
    
  }
  else{
      //size(400, 400);
      fill(0);
      textSize(64);
      text("establish an arduino connection", 40, 300); 
  }
}

void serialEvent(Serial p) {
  // Split incoming packet on commas
  // See https://github.com/kitschpatrol/Arduino-Brain-Library/blob/master/README for information on the CSV packet format
  
  //String incomingString = p.readString().trim();
   //while (p.available() >0){
       String incomingString = p.readStringUntil('\n');
       if (incomingString == null){
         return;
       }
       else{
         String trimmed = incomingString.trim();
         println(trimmed + " is incoming string; " + "err1 is other; " + trimmed.equals("err1") + " is result of equals");  
         String[] incomingValues = split(trimmed, ',');
         if (incomingString.equals("err1") || incomingValues.length == 1){
           println("Received error over serial: " + incomingString);
           headsetOn=0;
         }
         else{
           println("INCOMING STRING IS " + incomingString);
           headsetOn=1;
       
           if (incomingValues.length > 1) {
             packetCount++;
             // Wait till the third packet or so to start recording to avoid initialization garbage.
             if (packetCount > 3) {
               for (int i = 0; i < incomingValues.length; i++) {
                 String stringValue = incomingValues[i].trim();
                 int newValue = Integer.parseInt(stringValue);
                  // Zero the EEG power values if we don't have a signal.
                  // Can be useful to leave them in for development.
                  //if ((Integer.parseInt(incomingValues[0]) == 200) && (i > 2)) {
                  //  newValue = 0;
                  //}
                  //println(" processing: " + newValue);
                 channels[i].addDataPoint(newValue);
               }
             }
           }
       }
       //String incomingString = p.readString().;
       
       
      
       
       //}
       


   }
   //  String incomingString = p.readStringUntil('\n');
     
     
     
     
   //}
  
  //String incomingString = p.readString();
   //String incomingString = p.readStringUntil('\n');

//  print("Received string over serial: ");
//  println(incomingString);  
  
  //String[] incomingValues = split(incomingString, ',');

  // Verify that the packet looks legit

}


// Utilities

// Extend Processing's built-in map() function to support the Long datatype
long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

// Extend Processing's built-in constrain() function to support the Long datatype
long constrainLong(long value, long min_value, long max_value) {
  if (value > max_value) return max_value;
  if (value < min_value) return min_value;
  return value;
}
void pickRandomColor() {
  currColor = color(random(256), random(256), random(256));
  nextColor = color(random(256), random(256), random(256));
}
void setupHelper(){
  // abstracts a lot of the uninteresting setup code to make code more readable
  
  frameRate(60);
  pickRandomColor();
  smooth();
  noFill();
  // Create the channel objects
  channels[0] = new Channel("Signal Quality", color(0), "");
  channels[1] = new Channel("Attention", color(100), "");
  channels[2] = new Channel("Meditation", color(50), "");
  channels[3] = new Channel("Delta", color(219, 211, 42), "Dreamless Sleep");
  channels[4] = new Channel("Theta", color(245, 80, 71), "Drowsy"); // red
  channels[5] = new Channel("Low Alpha", color(237, 0, 119), "Relaxed"); // green
  channels[6] = new Channel("High Alpha", color(212, 0, 149), "Relaxed");
  channels[7] = new Channel("Low Beta", color(158, 18, 188), "Alert"); // blue
  channels[8] = new Channel("High Beta", color(116, 23, 190), "Alert");
  channels[9] = new Channel("Low Gamma", color(39, 25, 159), "Multi-sensory processing");
  channels[10] = new Channel("High Gamma", color(23, 26, 153), "???");

  // Manual override for a couple of limits.
  channels[0].minValue = 0;
  channels[0].maxValue = 200;
  channels[1].minValue = 0;
  channels[1].maxValue = 100;
  channels[2].minValue = 0;
  channels[2].maxValue = 100;
  channels[0].allowGlobal = false;
  channels[1].allowGlobal = false;
  channels[2].allowGlobal = false;
}
