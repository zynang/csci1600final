class Graph {
  // View class to draw a graph of the channel model's values over time.
  // Used as a singleton.

  int x,y, w, h, hex_val;;
  float r, g, b;
 

  Graph(int _x, int _y, int _w, int _h, float _r, float _g, float _b) {
    x = _x; // x loc of ellipse
    y = _y; // y loc of ellipse
    w = _w; // width of ellipse
    h = _h; // height of ellipse
    r = _r; // red
    g = _g; // green
    b = _b; // blue
        

  }


  void draw() {
   
    fill(r, g, b);
    ellipse(x, y, w, h);
    
   
     for (int i : new int[]{4, 5, 7}) {
      Channel thisChannel = channels[i];
        
         Point thisPoint = (Point) thisChannel.getLatestPoint();
         if (i == 4){
           r = map(thisPoint.value, 0, 1200000, 0, 255); //drowsy
           w = (int) map(thisPoint.value, 0, 1200000, 0, disp_x/2);
           //println("r: " + r);
         }
         else if (i == 5){
           g = map(thisPoint.value, 0, 350000, 0, 255); // relaxed
           //println("g: " + g); // relaxed
         }
         else if (i == 7){
           b = map(thisPoint.value, 0, 160000, 0, 255); // alert
           h = (int) map(thisPoint.value, 0, 160000, 0, disp_y /2); // alert

           //println("b: " + b); // alert
         }
         else {
         print("error reading from channel");
         }
         
     

    }


  }
}
