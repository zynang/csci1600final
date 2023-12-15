class Rect {
  // Rectangle object to create the visualization
  
  color c1, c2, c3;
  float r, g, b;

  Rect() {
    colorMode(RGB, 255, 255, 255);
    c1 = 0;
    c2 = 0;
    c3 = 0;
  }

  void draw() {
    int rW = 0;
    int gW = 0;
    int bW = 0;
    
    for (int i : new int[]{1, 2, 3}) {
      Channel thisChannel = channels[i];
      Point thisPoint = (Point) thisChannel.getLatestPoint();

      if (i == 1) {
        r = map(thisPoint.value, 0, 100, 0, 255); // Attention
        c1 = color(255, 105, 180, r);

      } else if (i == 2) {
        g = map(thisPoint.value, 0, 100, 0, 255); // Meditation
        c2 = color(255, 255, 0, g);

      } else if (i == 3) {
        b = map(thisPoint.value, 100000, 3000000, 0, 255); // Dreamless Sleep
        c3 = color(0, 191, 255, b);
      } else {
        print("error reading from channel");
      }
    }
    
    int total = (int) (r + g + b);

    if (r != 0 && g != 0 && b !=0 ){
      rW = (int)((r / total) * (width - 600));
      gW = (int)((g / total) * (width - 600));    
      bW = (int)((b / total) * (width - 600));
    }
   
    fillGradient(100, height/2, 300, rW, gW, bW, c1, c2,c3);
  }


  void fillGradient(int x, int y, float h, int rW, int gW, int bW, color r, color g, color b){
  
    // red region
    for (int i = x; i <= x+rW; i++){
      stroke(r);
      line(i, y-h, i, y+h);
    }
    
    // gradient for 10 spaces
    for (int j = x+rW+1; j <= x+rW + 200; j++){
     float inter = map(j, x+rW,  x+rW + 200, 0, 1);
     color c = lerpColor(r, g, inter);
     stroke(c);
     line(j, y-h, j, y+h);
    }
    
    // green region
    for (int k = x+rW + 201; k <= x+rW + 200 + gW; k++){
      stroke(g);
      line(k, y-h, k, y+h);
    }
    
      
    // gradient for 10 spaces
    for (int l = x+rW + 200 + gW +1; l <= x+rW + 200 + gW + 200; l++){
     float inter = map(l, x+rW + 200 + gW,  x+rW + 200 + gW+ 200, 0, 1);
     color c = lerpColor(g, b, inter);
     stroke(c);
     line(l, y-h, l, y+h);
    }
    
     // blue region
    for (int m = x+rW + 200 + gW + 200 + 1; m <= x+rW + 200 + gW + 200 +bW; m++){
      stroke(b);
      line(m, y-h, m, y+h);
    }
    
    
  }
  
  void interruptDrawRandomRectangle(int h){
    // Call this in the brainGrapher to draw a random rectangle when the interrupt is called
    
    int rW = 0;
    int gW = 0;
    int bW = 0;
    
    for (int i : new int[]{1, 2, 3}) {
      Channel thisChannel = channels[i];
      Point thisPoint = (Point) thisChannel.getLatestPoint();

      if (i == 1) {
        r = map(thisPoint.value, 0, 100, 0, 255); // Attention
        c1 = color(random(0,255), random(0,255), random(0,255), r);

      } else if (i == 2) {
        g = map(thisPoint.value, 0, 100, 0, 255); // Meditation
        c2 = color(random(0,255), random(0,255), random(0,255), g);

      } else if (i == 3) {
        b = map(thisPoint.value, 100000, 3000000, 0, 255); // Dreamless Sleep
        c3 = color(random(0,255), random(0,255), random(0,255), b);
      } else {
        print("error reading from channel");
      }
    }
    
    int total = (int) (r + g + b);

    if (r != 0 && g != 0 && b !=0 ){
      rW = (int)((r / total) * (width - 600));

      gW = (int)((g / total) * (width - 600));    

      bW = (int)((b / total) * (width - 600));
    }
   
    fillGradient(100, height/2, h, rW, gW, bW, c1, c2,c3);
  }
  
}
