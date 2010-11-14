CAS t;



void setup() {
  background(255,255,255); colorMode(RGB, 255,255,255, 1.0);
  smooth(); stroke(0,0,0);
  size(600, 600);
  draw_once();
}


abstract class CAS { //CartesianAutonomousSystem
  
  float x0, x1, y0, y1;
  float deltax, deltay;
  
  abstract float dx(float x, float y);
  abstract float dy(float x,float y);
  
  PVector translate(float x, float y) { //graph to real
    return new PVector( width*(x-x0)/(x1-x0), height - height*(y-y0)/(y1-y0));
  }
  
  PVector untranslate(float x, float y) { //real to graph
    return new PVector(x*(x1-x0)/width + x0, (height - y)*(y1 - y0)/height + y0);
  }
  
  void trline(float x, float y, float u, float v, boolean arrow) {
    PVector st = translate(x,y); PVector end = translate(u,v);
    line(st.x, st.y, end.x, end.y);
    if(arrow) { ellipse(end.x, end.y, 2, 2); };
  }
  void trline(float x, float y, float u, float v) {
    trline(x,y,u,v,false);
  }
  
  CAS(float x0i, float x1i, float y0i, float y1i) {
    x0 = x0i; x1 = x1i; y0 = y0i; y1 = y1i;
    deltax = (x1-x0)/30; deltay = (y1-y0)/30;
  }
  
  void draw() {   
    stroke(0,0,0,1);
    trline(0, y0, 0, y1); trline(x0, 0, x1, 0);
    
    stroke(0,0,0,0.5);
    for(float x = x0; x < x1; x += deltax) {
    for(float y = y0; y < y1; y += deltay) {
      trline(x,y, x+dx(x,y)/10, y+dy(x,y)/10, true);
    }}
    
  }
  
  void do_euler_approx(float x, float y, float tmin, float tmax) {
     stroke(255,0,0,1);
     float step = 0.05;
     PVector current_pos = new PVector(x,y); PVector new_pos = new PVector(x,y);
     for(float t = 0; t > tmin; t -= step) {
       println("t is " + t);
       new_pos = PVector.sub(current_pos, 
                             new PVector(step * dx(current_pos.x, current_pos.y), 
                                         step * dy(current_pos.x, current_pos.y)));
       trline(current_pos.x, current_pos.y, new_pos.x, new_pos.y);
       current_pos = new_pos;
     }
     current_pos = new PVector(x,y); new_pos = new PVector(x,y);
     for(float t = 0; t < tmax; t += step) {
       println("t is " + t);
       new_pos = PVector.add(current_pos, 
                             new PVector(step * dx(current_pos.x, current_pos.y), 
                                         step * dy(current_pos.x, current_pos.y)));
       trline(current_pos.x, current_pos.y, new_pos.x, new_pos.y);
       current_pos = new_pos;
     }
  }
  
}


void draw_once() {  
  /* //attractive critical point at 1/3,1/3  repulsive at origin
  class Test extends CAS {
    public float dx(float x,float y) { return x*(1 - 2*x - y); }
    public float dy(float x,float y) { return y*(1 - x - 2*y); }
    Test(float x0, float x1, float y0, float y1) { super(x0,x1,y0,y1); };
  }
  t = new Test(-0.1, 0.5, -0.1, 0.5); t.draw();
  */
  
  class Test extends CAS {
    public float dx(float x, float y) { return y; };
    public float dy(float x, float y) { return y*y + x - x*x; };
    Test(float x0, float x1, float y0, float y1) { super(x0,x1,y0,y1); };
  }  
  t = new Test(-1, 1.5, -1, 1); t.draw();
  /*//cool spiral!! 
  class Test extends CAS {
    public float dx(float x, float y) { return  - y - x*(x*x + y*y); };
    public float dy(float x, float y) { return x - y*(x*x + y*y); };
    Test(float x0, float x1, float y0, float y1) { super(x0,x1,y0,y1); };
  } 
  t = new Test(-1, 1, -1, 1); t.draw();  */
  
  /* //ellipses!
  class Test extends CAS {
    public float dx(float x, float y) { return y*exp(x*y); };
    public float dy(float x, float y) { return 1 - x*x*x*x - y*y; };
    Test(float x0, float x1, float y0, float y1) { super(x0,x1,y0,y1); };
  }
  t = new Test(-1.5, 1.5, -1.5, 1.5); t.draw();*/ 
}

void draw() {
  //do nothing!
}

void mousePressed() {
  println("MOUSE PRESSED!!");
  PVector pos = t.untranslate(mouseX, mouseY);
  t.do_euler_approx(pos.x, pos.y, 0, 1);
}
