import javax.swing.*;
CAS t;



void setup() {
  background(255,255,255); colorMode(RGB, 255,255,255, 1.0);
  smooth(); stroke(0,0,0);
  size(600, 600);
  draw_once();
}

class D {
  public float f(float x, float y) {return 0.0; };
}
class CAS { //CartesianAutonomousSystem
  
  float x0, x1, y0, y1;
  float deltax, deltay;
  D dx, dy;
  
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
  
  CAS(float x0i, float x1i, float y0i, float y1i, D dxi, D dyi) {
    x0 = x0i; x1 = x1i; y0 = y0i; y1 = y1i; dx = dxi; dy = dyi;
    deltax = (x1-x0)/30; deltay = (y1-y0)/30;
  }
  
  void draw() {   
    stroke(0,0,0,1);
    trline(0, y0, 0, y1); trline(x0, 0, x1, 0);
    
    stroke(0,0,0,0.5);
    for(float x = x0; x < x1; x += deltax) {
    for(float y = y0; y < y1; y += deltay) {
      trline(x,y, x+dx.f(x,y)/10, y+dy.f(x,y)/10, true);
    }}
    
  }
  
  void drawCritical() {
    //have a guess at where the critical points could be
    //take the manhattan metric of the derivatives, put a dot where
    //this is small
    float epsilon = 0.01;
    for(float x = x0; x < x1; x += deltax/10) {
    for(float y = y0; y < y1; y += deltay/10) {
      if(abs(dx.f(x,y)) + abs(dy.f(x,y)) < epsilon) { //manhattan metric
        PVector p = translate(x,y);
        ellipse(p.x,p.y,2,2);
      }
    }}
  }
  
  void doEulerApprox(float x, float y, float tmax) {
    //approximate trajectory from mouse click using basic euler approx
    stroke(255,0,0,1);
    float step = 0.05;
    //setup bounds - stop trying to approximate all the way to infinity...
    float xmin = x0 - (x1-x0)*2; float xmax = x1 + (x1-x0)*2;
    float ymin = y0 - (y1-y0)*2; float ymax = y1 + (y1-y0)*2;
    PVector pos = new PVector(x,y); PVector new_pos = new PVector(x,y);
    for(float t = 0; t < tmax && xmin < pos.x && pos.x < xmax && ymin < pos.y && pos.y < ymax; t += step) {
      new_pos = PVector.add(pos, 
                            new PVector(step * dx.f(pos.x, pos.y), 
                                        step * dy.f(pos.x, pos.y)));
      trline(pos.x, pos.y, new_pos.x, new_pos.y);
      pos = new_pos;
    }
  }
  
}


void draw_once() {  
   
  /*//attractive critical point at 1/3,1/3  repulsive at origin
  t = new CAS(-0.1, 1, -0.1, 1, new D() {public float f(float x, float y) {return x*(1 - 2*x - y);}},
                                    new D() {public float f(float x, float y) {return y*(1 - x - 2*y);}});
  //*/
  
   //saddle at origin, orbit at (1,0)
  t = new CAS(-1, 1.5, -1, 1, new D() {public float f(float x, float y) {return y;}},
                              new D() {public float f(float x, float y) {return y*y + x - x*x; }}); 
  //*/
  
  /* //cool spiral!! 
  t = new CAS(-1, 1, -1, 1, new D() {public float f(float x, float y) {return - y - x*(x*x + y*y);}},
                            new D() {public float f(float x, float y) {return x - y*(x*x + y*y);}});
  // */
  
  /* //ellipses!
  t = new CAS(-1.5, 1.5, -1.5, 1.5, new D() {public float f(float x, float y) {return y*exp(x*y);}},
                                    new D() {public float f(float x, float y) {return 1 - x*x*x*x - y*y;}});
  //*/ 
  
  t.draw(); t.drawCritical();
}

void draw() {
  //do nothing!
}

void mousePressed() {
  println("MOUSE PRESSED!!");
  PVector pos = t.untranslate(mouseX, mouseY);
  t.doEulerApprox(pos.x, pos.y, 10);
}

//save
void keyPressed() {
  if
  SwingUtilities.invokeLater(new Runnable() {
    public void run() {
      JFileChooser chooser = new JFileChooser();
      chooser.setFileFilter(chooser.getAcceptAllFileFilter());
      int returnVal = chooser.showSaveDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        save(chooser.getSelectedFile().getName() + ".png");
      }
    }
  });
}
