
void testButtonInterrupt() {
  // This test checks whether the button interrupt works as expected. 
  // We expect the button to change the value of "i" when pressed. 
    i = "off";

    buttonInterrupt();

    if(i == "on"){
      Serial.println("TEST 1 :: passed - button interrrupt - on");
    }
    else{
      Serial.println("TEST 1 :: failed - button interrrupt - on");
    }

    buttonInterrupt();

    if(i == "off"){
     Serial.println("TEST 1 :: passed - button interrrupt - off");
    }
    else{
      Serial.println("TEST 1 :: failed - Button interrrupt - off");
    }

}


void testNoData(){
  
  // don't turn on headset for this to pass
  
  if(err == "err1"){
    Serial.println("TEST 2 :: passed - err1");
  }
  else{
    Serial.println("TEST 2 :: failed - err1(needs more time to trigger error)");
  }

}

void testWatchDogTimer(){
  delay(4500);
}

// Test wifi




