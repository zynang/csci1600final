import processing.serial.*;

Serial serial;
Channel[] channels = new Channel[11];
Rect rect;

enum State {
  ARDUINO_ERROR, CONNECTION_ERROR, VISUALIZATION, INTERRUPT
};
int packetCount = 0;
int globalMax = 0;
boolean headsetOn = false;
int currColor;
int nextColor;
int timeSinceLastColorChange = 0;
int currR;
int currG;
int currB;
int rectGrowth = 0;
State currState = State.ARDUINO_ERROR;
State nextState = State.ARDUINO_ERROR;
boolean growing = false;
boolean nextColorReached = false;
boolean interruptStatus = false;
int counter = 0;

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
  
  serial = new Serial(this, Serial.list()[5], 9600);
  serial.bufferUntil(10);
  rect = new Rect();
}
void draw() {
  readSerial(serial);
  updateInputs(serial);
  background(255);
  currState = nextState;
  // FSM
  switch (currState){
    // STATE 1
    case ARDUINO_ERROR:
      // 1-1 Circuit is down or Headset is off (receiving err1)
      if (!headsetOn) { // TODO: or circuit is down? maybe not
        drawHeadsetError();
        nextState = State.ARDUINO_ERROR;
      }
      // 1-2 Headset is connected but is getting bad values (200 for first, 0 for second and 0 for third)
      else if (headsetOn && !isGoodConnection()){
        nextState = State.CONNECTION_ERROR;
      }
      // 1-3 Headset is on and getting good values (no interrupt)
      else if(headsetOn && isGoodConnection()){
        //rect.draw();
        nextState = State.VISUALIZATION;
      }
      break;
    // 2
    case CONNECTION_ERROR:
      // 2-1 (receiving err1)
      if (!headsetOn) { 
        nextState = State.ARDUINO_ERROR;
      }
      // 2-2 Headset is on but is getting bad values (200 for first, 0 for second and 0 for third)
      else if ((headsetOn && !isGoodConnection())){
        drawConnectionError();
        nextState = State.CONNECTION_ERROR;
      }
      // 2-3 Headset is on and getting good values (no interrupt)
      else if(headsetOn && isGoodConnection() && !interruptStatus){
        nextState = State.VISUALIZATION;
      }
      break;
    // 3
    case VISUALIZATION:
      // 3-1 (receiving err1)
      if (!headsetOn){
        nextState = State.ARDUINO_ERROR;
      }
      // 3-2 (200 for first, 0 for second and third)
      else if (headsetOn && !isGoodConnection()){
        nextState = State.CONNECTION_ERROR;
      }
      // 3-3 (good values start coming in, not 200 and rest are something AND no interrupt)
      else if (headsetOn && isGoodConnection() && !interruptStatus){
        rect.draw();
        nextState = State.VISUALIZATION;
      }
      // 3-4 (good values AND interrupt)
      else if (headsetOn && isGoodConnection() && interruptStatus){
        nextState = State.INTERRUPT;
      }
      break;
    // 4
    case INTERRUPT:
      // 4-1 (receiving err1)
      if (!headsetOn){
        nextState = State.ARDUINO_ERROR;
      }
      // 4-2 (bad values)
      else if (headsetOn && !isGoodConnection()){
        nextState = State.CONNECTION_ERROR;
      }
      // 4-3 (good values and no interrupt)
      else if (headsetOn && isGoodConnection() && !interruptStatus){
        nextState = State.VISUALIZATION;
      }
      // 4-4 (good values and interrupt)
      else if (headsetOn && isGoodConnection() && interruptStatus){
        if (growing){
          rectGrowth+=1;
        }
        else{
          rectGrowth-=1;
        }
        rect.interruptDrawRandomRectangle(rectGrowth);
        nextState = State.INTERRUPT;
      }
      break;
    // should never be reached!!!
    default:
      println("You did bad things! You should not reach here!");
      nextState = currState;
      break;  
    };
}

boolean isGoodConnection(){
  return (channels[0].getLatestPoint().value != 200 && channels[1].getLatestPoint().value!= 0 && channels[2].getLatestPoint().value != 0);
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
void drawConnectionError(){
  String err_msg1 = "Headset is on...";
  String err_msg2 = "But no/bad connection detected!";
  String err_msg3 = ":-(";
  String err_msg4 = "Check ear connection!";
  estimateColor();
  textSize(70);
  text(err_msg1, 475, 400);
  text(err_msg2, 275, 500);
  text(err_msg3, 700, 600);
  text(err_msg4, 400, 700);
}
void drawHeadsetError(){
  estimateColor();
  textSize(70);
  text("Turn on the headset!!!", 220, 400);
  text("Might be buffering if just reset...", 220, 500);
  text("<(•-•<)", 650, 700);
}
void readSerial(Serial p) {
   String incomingString = p.readStringUntil('\n');
   if (incomingString == null){
     return;
   }
   else{
     String trimmed = incomingString.trim();
     String[] typeOfInput = split(trimmed, ' ');
     if (incomingString.equals("err1") || typeOfInput.length == 1){
       counter++;
       println("Received error over serial: " + incomingString + str(counter));
       headsetOn=false;
     }
     else{
       String[] incomingBrainWaveData;

       if (typeOfInput[0].equals("b:")){
         incomingBrainWaveData = split(typeOfInput[1], ',');       
         println("Incoming string is: " + incomingString);
         headsetOn=true;
   
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
         if (typeOfInput[1].equals("on") && currState==State.VISUALIZATION){
           interruptStatus = true;
         }
         else if (typeOfInput[1].equals("off") && currState==State.INTERRUPT){
           interruptStatus = false;
         }
         else{
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
         println("Uncaught exception " + incomingString);
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
