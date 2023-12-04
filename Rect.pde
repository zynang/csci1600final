class Rect {
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
    
    float rAlpha = 0;
    float gAlpha = 0;
    float bAlpha = 0;
    for (int i : new int[]{1, 2, 3}) {
      Channel thisChannel = channels[i];
      Point thisPoint = (Point) thisChannel.getLatestPoint();

      if (i == 1) {
        //int currRead = thisPoint.value;
        //rW = int(map(thisPoint.value, 0,100,0,255));
        //rW = int(random(0,255));
        r = map(thisPoint.value, 0, 100, 0, 255); // Attention
        //r = map(thisPoint.value, 0, 100, 0, 1); // Attention
        c1 = color(255, 105, 180, r);
        //c1 = color(255, 0, 0, 255);

      } else if (i == 2) {
        g = map(thisPoint.value, 0, 100, 0, 255); // Meditation
        //gW = int(map(thisPoint.value,0,100,0,255));
        //gW = int(random(0,255));
        //g = map(thisPoint.value, 0, 100, 0, 1); // Meditation

        c2 = color(255, 255, 0, g);
        //c2 = color(255, 255, 0, 255);

      } else if (i == 3) {
        b = map(thisPoint.value, 100000, 3000000, 0, 255); // Dreamless Sleep
        //bW = int(map(thisPoint.value,0,100,0,255));
        //bW = int(random(0,255));
        //b = map(thisPoint.value, 100000, 3000000, 0, 1); // Dreamless Sleep
        c3 = color(0, 191, 255, b);
        //c3 = color(0, 0, 255, 255);
      } else {
        print("error reading from channel");
      }
    }
    
    int total = (int) (r + g + b);
    //int total = (int) (255 + 0.5*255 + 0.5*255x);
          //println("total: " + r + g + b);

    if (r != 0 && g != 0 && b !=0 ){
      //println(rW);
      rW = (int)((r / total) * (width - 600));
      //println(rW);
      //println("red: " + (r / total) );

      gW = (int)((g / total) * (width - 600));    
      //println("green: " + (g / total) );

      bW = (int)((b / total) * (width - 600));
           //println("blue: " + (b / total) );
    }
   
    fillGradient(100, height/4, height/2, rW, gW, bW, c1, c2,c3);

  }


  void fillGradient(int x, int y, float h, int rW, int gW, int bW, color r, color g, color b){
  
    // red region
    for (int i = x; i <= x+rW; i++){
      stroke(r);
      line(i, y, i, y+h);
    }
    
    // gradient for 10 spaces
    for (int j = x+rW; j <= x+rW + 200; j++){
     float inter = map(j, x+rW,  x+rW + 200, 0, 1);
     color c = lerpColor(r, g, inter);
     stroke(c);
     line(j, y, j, y+h);
    }
    
    // green region
    for (int i = x+rW + 200; i <= x+rW + 200 + gW; i++){
      stroke(g);
      line(i, y, i, y+h);
    }
    
      
    // gradient for 10 spaces
    for (int j = x+rW + 200 + gW; j <= x+rW + 200 + gW + 200; j++){
     float inter = map(j, x+rW + 200 + gW,  x+rW + 200 + gW+ 200, 0, 1);
     color c = lerpColor(g, b, inter);
     stroke(c);
     line(j, y, j, y+h);
    }
    
     // blue region
    for (int i = x+rW + 200 + gW + 200; i <= x+rW + 200 + gW + 200 +bW; i++){
      stroke(b);
      line(i, y, i, y+h);
    }
    
   
    
    
  }
  
}
