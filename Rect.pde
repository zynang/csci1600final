class Rect {
  color c1, c2, c3;
  float r, g, b;

  Rect() {
    c1 = 0;
    c2 = 0;
    c3 = 0;
  }

  void draw() {
    int rW = width/3;
    int gW = width/3;
    int bW = width/3;
    int b100 = 0;
    
    
    for (int i : new int[]{1, 2, 3}) {
      Channel thisChannel = channels[i];
      Point thisPoint = (Point) thisChannel.getLatestPoint();

      if (i == 1) {
        r = map(thisPoint.value, 0, 100, 0, 255); // Drowsy
        
        
        c1 = color(r, 0, 0);
      } else if (i == 2) {
        g = map(thisPoint.value, 0, 100, 0, 255); // Relaxed
        c2 = color(0, g, 0);
      } else if (i == 3) {
        b = map(thisPoint.value, 0, 4000000, 0, 255); // Alert
        b100 = (int)  map(thisPoint.value, 0, 4000000, 0, 100); 
        
        c3 = color(0, 0, b);
      } else {
        print("error reading from channel");
      }
    }
    
    int total = (int) (r + g + b100);
    if (r != 0 && g != 0 && b100!=0){
      rW = int(r / total * (width/2 - 20));
      gW = int(g / total * (width/2 - 20));    
     bW = int(b100 / total * (width/2 - 20));
    }
    
   // rW = int(r / total * (width - 30));
   // gW = int(g / total * (width - 30));    
   //bW = int(b100 / total * (width - 30));

    fillGradient(width/4, height/4, height/2, rW, gW, bW, c1, c2,c3);
    //setGradient(width/4, height/4, width/2, height/2, c1, c2, c3);
    //setGradient(50, 190, 540, 80, c2, c1, c3);
  }

  //void setGradient(int x, int y, float w, float h, color c1, color c2, color c3) {
  //  noFill();

  //  for (int i = x; i <= x + w; i++) {
  //    float inter = map(i, x, x + w, 0, 1);
  //    //color c = lerpColor(lerpColor(c1, c2, inter), c3, inter);
  //    //color c = lerpColor(c1, c2, inter);

  //    //color c = color(0,0,255);
  //    stroke(c);
  //    line(i, y, i, y + h);
  //  }
  //}
  
  
  void fillGradient(int x, int y, float h, int rW, int gW, int bW, color r, color g, color b){
  
    // red region
    for (int i = x; i <= x+rW; i++){
      stroke(r);
      line(i, y, i, y+h);
    }
    
    // gradient for 10 spaces
    for (int j = x+rW; j <= x+rW + 10; j++){
     float inter = map(j, x+rW,  x+rW + 10, 0, 1);
     color c = lerpColor(r, g, inter);
     stroke(c);
     line(j +rW, y, j+rW, y+h);
    }
    
    // green region
    for (int i = x+rW + 10; i <= x+rW + 10 + gW; i++){
      stroke(g);
      line(i+rW + 10, y, i+ rW + 10, y+h);
    }
    
      
    // gradient for 10 spaces
    for (int j = x+rW + 10 + gW; j <= x+rW + 10 + gW + 10; j++){
     float inter = map(j, x+rW + 10 + gW,  x+rW + 10 + gW+ 10, 0, 1);
     color c = lerpColor(g, b, inter);
     stroke(c);
     line(j+rW + 10 + gW, y, j+rW + 10 + gW, y+h);
    }
    
     // blue region
    for (int i = x+rW + 10 + gW + 10; i <= x+rW + 10 + gW + 10+bW; i++){
      stroke(b);
      line(x+rW + 10 + gW + 10, y, x+rW + 10 + gW + 10, y+h);
    }
    
   
    
    
  }
  
}
