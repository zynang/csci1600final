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
    
    
    for (int i : new int[]{1, 2, 3}) {
      Channel thisChannel = channels[i];
      Point thisPoint = (Point) thisChannel.getLatestPoint();

      if (i == 1) {
        //r = map(thisPoint.value, 0, 100, 0, 255); // Attention
         r = map(thisPoint.value, 0, 100, 0, 1); // Attention

        //c1 = color(r, 0, 0);
        //c1 = color(255, 0, 0, r);
        c1 = color(255, 0, 0, 1);

      } else if (i == 2) {
        //g = map(thisPoint.value, 0, 100, 0, 255); // Meditation
        g = map(thisPoint.value, 0, 100, 0, 1); // Meditation

        //c2 = color(255, g, 0);
        //c2 = color(255, 255, 0, g);
        c2 = color(255, 255, 0, 1);

      } else if (i == 3) {
        //b = map(thisPoint.value, 100000, 3000000, 0, 255); // Dreamless Sleep
        b = map(thisPoint.value, 100000, 3000000, 0, 1); // Dreamless Sleep
        //c3 = color(0, 0, 255, b);
        c3 = color(0, 0, 255, 1);


        
        //c3 = color(150, 150, b);
      } else {
        print("error reading from channel");
      }
    }
    
    //int total = (int) (r*255 + g*255 + b*255);
    int total = (int) (0.5*255 + 0.5*255 + 0.5*255);
          //println("total: " + r + g + b);

    if (r*255 != 0 && g*255 != 0 && b*255 !=0 ){
      rW = (int)((r*255 / total) * (width - 600));
      println("test");
      //println("red: " + (r / total) );

      gW = (int)((g*255 / total) * (width - 600));    
      //println("green: " + (g / total) );

     bW = (int)((b*255 / total) * (width - 600));
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
