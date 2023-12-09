//// Main controller / model file for the the Processing Brain Grapher.

//// See README.markdown for more info.
//// See http://frontiernerds.com/brain-hack for a tutorial on getting started with the Arduino Brain Library and this Processing Brain Grapher.

//// Latest source code is on https://github.com/kitschpatrol/Processing-Brain-Grapher
//// Created by Eric Mika in Fall 2010, updates Spring 2012 and again in early 2014.

//int n = 1000; // number of dots 

//float[] m = new float[n]; // make a new list of floating points 
//float[] x = new float[n];
//float[] y = new float[n];
//float[] vx = new float[n];
//float[] vy = new float[n];
//float[] redchannel = new float[n]; 
//float[] bluechannel = new float[n];
//float[] greenchannel = new float[n];
//float[] shape = new float[n];


//import processing.serial.*;

//Serial serial;

//Channel[] channels = new Channel[11];
//Graph graph;
//int disp_x, disp_y;

//int packetCount = 0;
//int globalMax = 0;
//String scaleMode;

//int sensorVal1;
//int sensorVal2;
//int sensorVal3;


//void setup() {
//  // Set up window

//  fullScreen();
//  fill(0,10);
//  reset();
  
//  serial = new Serial(this, "COM6", 9600);    
//  //serial.bufferUntil(10);


//  // Create the channel objects
//  channels[0] = new Channel("Signal Quality", color(0), "");
//  channels[1] = new Channel("Attention", color(100), "");
//  channels[2] = new Channel("Meditation", color(50), "");
//  channels[3] = new Channel("Delta", color(219, 211, 42), "Dreamless Sleep");
//  channels[4] = new Channel("Theta", color(245, 80, 71), "Drowsy"); // red
//  channels[5] = new Channel("Low Alpha", color(237, 0, 119), "Relaxed"); // green
//  channels[6] = new Channel("High Alpha", color(212, 0, 149), "Relaxed");
//  channels[7] = new Channel("Low Beta", color(158, 18, 188), "Alert"); // blue
//  channels[8] = new Channel("High Beta", color(116, 23, 190), "Alert");
//  channels[9] = new Channel("Low Gamma", color(39, 25, 159), "Multi-sensory processing");
//  channels[10] = new Channel("High Gamma", color(23, 26, 153), "???");

//  // Manual override for a couple of limits.
//  channels[0].minValue = 0;
//  channels[0].maxValue = 200;
//  channels[1].minValue = 0;
//  channels[1].maxValue = 100;
//  channels[2].minValue = 0;
//  channels[2].maxValue = 100;
//  channels[0].allowGlobal = false;
//  channels[1].allowGlobal = false;
//  channels[2].allowGlobal = false;

 

//  // Set up the graph
//  //graph = new Graph(disp_x/2, disp_y/2, disp_x/4, disp_x/4, 0,0,0);

//  //// Set yup the connection light
//  //connectionLight = new ConnectionLight(width - 140, 10, 20);
//}

//void draw() {
//  serialEvent(serial);
     
//     for (int c : new int[]{4, 5, 7}) {
//      Channel thisChannel = channels[c];
        
//      Point thisPoint = (Point) thisChannel.getLatestPoint();
//      if (c == 4){
//        sensorVal1 = thisPoint.value;
//        println("drowsy: " + sensorVal1);
        
//      }
//      else if (c == 5){
//        sensorVal2 = thisPoint.value;
//        println("relaxed: " + sensorVal2);
//      }
//     else if (c == 7){
//        sensorVal3 = thisPoint.value;
//        println("alert: " + sensorVal3);
//         }
//     else {
//        print("error reading from channel");
//      }
      
//    noStroke();
//    fill(0,30);
//    rect(0, 0, width, height); //  black background 
    
    
//    for (int i = 0; i < n; i++) { // runs the loop 10,000 times
//      float dx = mouseX - x[i]; // distance from the mouse 
//      float dy = sensorVal1 - y[i];
  
//      float d = sqrt(dx*dx + dy*dy); // calculating the distance between the points and the mouse 
//      if (d < 1) d = 1; 
  
//      float f = cos(d * 0.06) * m[i] / d*2; //decides if it gets closer or further from the mouse 
  
//      vx[i] = vx[i] * 0.4 - f * dx; //changing the velocity so it moves towards the ring 
//      vy[i] = vy[i] * 0.2 - f * dy;
//    }
    
//      for (int i = 0; i < n; i++) {
//        x[i] += vx[i];
//        y[i] += vy[i];
    
//        if (x[i] < 0) x[i] = width;
//        else if (x[i] > width) x[i] = 0;
    
//        if (y[i] < 0) y[i] = height;
//        else if (y[i] > height) y[i] = 0;
    
//        //if (m[i] < 0) fill(bluechannel[i], greenchannel[i] , 255);
//        //else fill(255, bluechannel[i],redchannel[i]);
    
//        //  if (shape[i] > 2) fill(bluechannel[i], greenchannel[i] , 255);
//        //else fill(255, bluechannel[i],redchannel[i]);
//        if (m[i] < 0) fill(map(sensorVal1, 0, 1200000, 0, 255), 0 , 0);
//        else fill(0,  map(sensorVal2, 0, 350000, 0, 255), 0);
    
//        if (shape[i] > 2) fill(map(sensorVal1, 0, 1200000, 0, 255), 0 , 0);
//        else fill(0, 0, map(sensorVal3, 0, 160000, 0, 255));     
    
    
    
//        if (shape[i] > 2)  rect(x[i], y[i],10,10);
//        else if (shape[i] > 1 && shape[i] <=2) rect(x[i],y[i],2,2);
//        else ellipse(x[i], y[i],10,10);



//  }
  

         
     

//    }
  
  
  
  
  
  
  
  
  
  
  
//  // Keep track of global maxima
//  if (scaleMode == "Global" && (channels.length > 3)) {
//    for (int i = 3; i < channels.length; i++) {
//      if (channels[i].maxValue > globalMax) globalMax = channels[i].maxValue;
//    }
//  }

//  // Clear the background
//  //background(255);

//  // Update and draw the main graph
//  //graph.update();
//  //graph.draw();

//}

//void serialEvent(Serial p) {
//  // Split incoming packet on commas
//  // See https://github.com/kitschpatrol/Arduino-Brain-Library/blob/master/README for information on the CSV packet format
  
//  //String incomingString = p.readString().trim();
//   while (p.available() >0){
//       String incomingString = p.readString();
//       incomingString.trim();
//       print("Received string over serial: ");

//       println(incomingString);  
//       String[] incomingValues = split(incomingString, ',');
       
//         if (incomingValues.length > 1) {
//            packetCount++;

//          // Wait till the third packet or so to start recording to avoid initialization garbage.
//          if (packetCount > 3) {
            
//            for (int i = 0; i < incomingValues.length; i++) {
//              String stringValue = incomingValues[i].trim();
      
//              int newValue = Integer.parseInt(stringValue);

      
//              // Zero the EEG power values if we don't have a signal.
//              // Can be useful to leave them in for development.
//              //if ((Integer.parseInt(incomingValues[0]) == 200) && (i > 2)) {
//              //  newValue = 0;
//              //}
//              println(" processing: " + newValue);

 
//              channels[i].addDataPoint(newValue);
//      }
//    }
//  } 


//   }
//   //  String incomingString = p.readStringUntil('\n');
     
     
     
     
//   //}
  
//  //String incomingString = p.readString();
//   //String incomingString = p.readStringUntil('\n');

////  print("Received string over serial: ");
////  println(incomingString);  
  
//  //String[] incomingValues = split(incomingString, ',');

//  // Verify that the packet looks legit

//}


//// Utilities

//// Extend Processing's built-in map() function to support the Long datatype
//long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
//  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
//}

//// Extend Processing's built-in constrain() function to support the Long datatype
//long constrainLong(long value, long min_value, long max_value) {
//  if (value > max_value) return max_value;
//  if (value < min_value) return min_value;
//  return value;
//}

//void reset() { // counter that counts up to n 
//  for (int i = 0; i < n; i++) { // i = 0, i < 10,0000, i++ what to do after each loop. 
//    m[i] = randomGaussian() * 8; // gaussian distribution is a bell curve. Distribution of the mass 
//    x[i] = random(width);
//    y[i] = random(height);
//    bluechannel[i] = random(255);
//    redchannel[i] = random(255);
//    greenchannel[i] = random(255); 
//    shape [i] = random(0,3); 
//  }
//}

////::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

//void mousePressed() {
//  reset();
//}
