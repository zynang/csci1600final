import processing.serial.*;

Serial serial;
Channel[] channels = new Channel[11];
Rect rect;

enum State {
  ARDUINO_ERROR, CONNECTION_ERROR, VISUALIZATION, INTERRUPT
};
int packetCount = 0;
int globalMax = 0;
int headsetOn = 0;
int currColor;
int nextColor;
int timeSinceLastColorChange = 0;
int currR;
int currG;
int currB;
int rectGrowth = 0;
boolean growing = false;
boolean nextColorReached = false;
boolean interruptStatus = false;

void setup() {
  // Set up window
  size(1440,960);
  setupHelper();
  // Comment in for Zyn
  //serial = new Serial(this, "COM6", 9600);    
  //serial.bufferUntil(10);
  
  // Comment in to find your port #
  //for (int i = 0; i < Serial.list().length; i++) {
  //  println("[" + i + "] " + Serial.list()[i]);
  //}
  
  // 5 on Joe's computer, 3 on Lynda/Haley's
  //serial = new Serial(this, Serial.list()[3], 9600);
  
  serial = new Serial(this, Serial.list()[3], 9600);
  serial.bufferUntil(10);
  rect = new Rect();
}

// TODO ADD GUARDS THAT CORRESPOND TO STATES
// STATE 1 = Arduino connection
// STATE 2 = Headset connection
// State 3 = Brainwave viz
// State 4 = interrupt viz 

// 1-1
// 1-2
// 1-3
// 2-2
// 2-3
// 2-1
// 3-3
// 3-4
// 3-2
// 3-1
// 4-4
// 4-3
// 4-2
// 4-1
void draw() {
  serialEvent(serial);
  // Keep track of global maxima
  updateInputs(serial);
  // Clear the background
  background(255);
  //
  if (headsetOn==1){
    if (channels[0].getLatestPoint().value == 200){
      String err_msg1 = "Headset is on...";
      String err_msg2 = "But no connection detected!";
      String err_msg3 = ":-(";
      estimateColor();
      textSize(70);
      text(err_msg1, 225, 400);
      text(err_msg2, 275, 500);
      text(err_msg3, 325, 600);
    }
    else{
      if (!interruptStatus){
        rect.draw();
      }
      else if (interruptStatus){
        if (growing){
          rectGrowth+=1;
        }
        else{
          rectGrowth-=1;
        }
        rect.interruptDrawRandomRectangle(rectGrowth);
      }
    }
    
  }
  else{
      estimateColor();
      textSize(70);
      text("Establish an Arduino connection!!!", 275, 400);
      text("<(•-•<)", 650, 600);
  }
}

void updateInputs(Serial serial) {
  if (channels.length > 3) {
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
}

void serialEvent(Serial p) {
       String incomingString = p.readStringUntil('\n');
       if (incomingString == null){
         return;
       }
       else{
         String trimmed = incomingString.trim();
         String[] typeOfInput = split(trimmed, ' ');
         if (incomingString.equals("err1") || typeOfInput.length == 1){
           println("Received error over serial: " + incomingString);
           headsetOn=0;
         }
         else{
           String[] incomingBrainWaveData;
  
           if (typeOfInput[0].equals("b:")){
             incomingBrainWaveData = split(typeOfInput[1], ',');       
             println("Incoming string is: " + incomingString);
             headsetOn=1;
       
             if (incomingBrainWaveData.length > 1) {
               packetCount++;
               // Wait till the third packet or so to start recording to avoid initialization garbage.
                 for (int i = 0; i < incomingBrainWaveData.length; i++) {
                   String stringValue = incomingBrainWaveData[i].trim();
                   int newValue = Integer.parseInt(stringValue);
                   channels[i].addDataPoint(newValue);
                 }
               }
           } 
           // Interrupt triggered
           else if (typeOfInput[0].equals("i:")){
             // adjust the global variable
             if (typeOfInput[1].equals("on")){
               interruptStatus = true;
             }
             else if (typeOfInput[1].equals("off")){
               interruptStatus = false;
             }
           }
           else if (typeOfInput[0].equals("O:")){
             String cleaned = incomingString.trim();
             Integer num = Integer.parseInt(cleaned.substring(3));
             if (num == 0){
               growing = false;
             }
             else{
               growing = true;
             }
           }
           else{
             println("Other random serial input");
           }
       }
   }
}
// Utilities

void estimateColor(){
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
  channels[1] = new Channel("Attention", color(100), ""); // pink
  channels[2] = new Channel("Meditation", color(50), ""); // yellow
  channels[3] = new Channel("Delta", color(219, 211, 42), "Dreamless Sleep"); //blue
  channels[4] = new Channel("Theta", color(245, 80, 71), "Drowsy");
  channels[5] = new Channel("Low Alpha", color(237, 0, 119), "Relaxed");
  channels[6] = new Channel("High Alpha", color(212, 0, 149), "Relaxed");
  channels[7] = new Channel("Low Beta", color(158, 18, 188), "Alert"); 
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
