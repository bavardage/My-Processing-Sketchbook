ArrayList pens = new ArrayList();


float pi2 = 2*(float)Math.PI;

void setup() {
   size(800,800);
   smooth(); 
   Loopy l = new Loopy(400, 400, 0.0, 1.2, 0, 0, 0.01, 0);
   pens.add(l);
}


class Loopy {
  float x,y;
  float angle;
  float factor;
  float xoff, yoff, dx, dy;
  
  Loopy(float tx, float ty, float tangle, float tfactor, 
        float txoff, float tyoff, float tdx, float tdy) {
    x = tx; y = ty; angle = tangle; factor = tfactor;
    xoff = txoff; yoff = tyoff; dx = tdx; dy = tdy;
  }
  
  void move() {
   xoff += dx; yoff += dy; 
   float dtheta = (noise(xoff, yoff) - 0.5)*factor;
   angle += dtheta;
   
   while(angle >= pi2) { 
     angle -= pi2; 
   }
   while(angle < 0) {
    angle += pi2;
   }
   
   float x2 = x + (float) Math.cos(angle);
   float y2 = y + (float) Math.sin(angle);
   line(x,y,x2,y2);
   x = x2; y = y2;
   
   if(-0.3 <= angle && angle <= 0.3 && random(1.0) > 0.9) {
     pens.add(new Loopy(x,y,angle,factor*-0.5, xoff, yoff, 0, dx));
   }
   
  }
}


void draw() {
  int n = pens.size();
  for(int i=0; i < n; i++) {
    ((Loopy)pens.get(i)).move();   
  }
}
