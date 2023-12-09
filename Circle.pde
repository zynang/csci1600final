class Circle{
  int dim;
  
  Circle(){
    
    dim = 1440/2;
    colorMode(HSB, 360, 100, 100);
    noStroke();
    ellipseMode(RADIUS);
    frameRate(1);
    
  }
  
  
  void draw() {
    background(0);
    for (int x = 0; x <= width; x+=dim) {
      drawGradient(x, height/2);
      } 
  }
  
  void drawGradient(float x, float y) {
    int radius = dim/2;
    float[] hues = new float[3];
    float r = 0; 
    float g = 0;
    float b = 0;
    
    
    
     for (int i : new int[]{4, 5, 7}) {
      Channel thisChannel = channels[i];
        
         Point thisPoint = (Point) thisChannel.getLatestPoint();
         if (i == 4){
           //println("drowsy: " + thisPoint.value);

           r = map(thisPoint.value, 0, 1200000, 0, 120); //drowsy
           //w = (int) map(thisPoint.value, 0, 1200000, 0, disp_x/2);
           println("r drowsy: " + r);
         }
         else if (i == 5){
           //println("relaxed: " + thisPoint.value);

           g = map(thisPoint.value, 0, 350000, 120, 240);
           // relaxed
           println("g relaxed: " + g); // relaxed
         }
         else if (i == 7){
           //println("alert: " + thisPoint.value);

           b = map(thisPoint.value, 0, 160000, 240, 360); // alert
           //h = (int) map(thisPoint.value, 0, 160000, 0, disp_y /2); // alert

           println("b alert: " + b); // alert
         }
         else {
         print("error reading from channel");
         }
         
     }
     
       hues[0] = r;
       hues[1] = g;
       hues[2] = b;
       
       

   
  
    for (int rad = radius; rad > 0; --rad) {
    for (int i = 0; i < 3; i++) {
      //float h = random(0, 360);

      fill(hues[i], 90, 90);
      //fill(h, 90, 90);

      ellipse(x, y, rad, rad);
      hues[i] = (hues[i] + 1) % 360;
      //h = (h + 1) % 360;

    }
  }
     

    }
}


  
  
  
