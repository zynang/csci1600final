
// This test verifies connection between arduino and mindflex by checking the value of 
// the signalStrength. Connection is fully established when signalStrength is 0
void testSignalStrength(){
 
 // for this test to pass, turn on headset but do not put it on
 
 if(signalStrengthError = "Headset is on but no connection detected!"){
   Serial.println("TEST 3 :: passed - signalStrength");
 }
 else{
   Serial.println("TEST 3 :: failed");
 }
}
