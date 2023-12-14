// To run these tests, you must upload the arduino code

// Testing the visualization for a singular brainwave serial input
void testSingularBrainWaveSerialInput(){
  Serial.println("b: 0,44,61,626962,26235,3103,15719,23192,9544,10487,4116");
}

// Testing the visialization for the Interrupt Service Routine
void testSingularInterruptSerialInput(){
  Serial.println("i: on");
}

// Testing the visialization for the Arduino Connection Error
void testArduinoConnectionError(){
  Serial.println("err1");
}

// Testing the visualization for a singular brainwave serial input
void testHeadsetConnectionError(){
  Serial.println("b: 200,44,61,626962,26235,3103,15719,23192,9544,10487,4116");
}

