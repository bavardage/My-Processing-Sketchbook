float pi2 = 2 * (float)Math.PI;

ArrayList pens = new ArrayList();
ArrayList kill = new ArrayList();

abstract class Pen {
  
  float angle;
  PVector pos;
  
  Pen() {
    pens.add(this); 
  }
  void kill() {
    kill.add(this);
  }
  void move() {
    newAngle();
    normaliseAngle();
    decay();
    
    PVector newpos = PVector.add(pos,
                                 angleToVector(angle));
    setStroke();
    line(pos.x, pos.y, newpos.x, newpos.y);
    pos = newpos;
    spawnNew();    
  }
  abstract void newAngle(); 
  abstract void decay();
  abstract void spawnNew();
  void setStroke() {
    return; 
  }
  PVector angleToVector(float angle, float magnitude) {
    PVector v = new PVector((float) Math.cos(angle), (float) Math.sin(angle));
    v.mult(magnitude);
    return v; 
  } 
  PVector angleToVector(float angle) {
    return angleToVector(angle, 1.0); 
  }
  void normaliseAngle() {
    while(angle < -Math.PI) angle += pi2;
    while(angle >= Math.PI) angle -= pi2;
  }
}

class PerlinPen extends Pen {
   PVector noisePos;
   PVector dNoisePos;
   float jitter;
   float life;
   float decay;
   
   PerlinPen(PVector p, float a, PVector nP, PVector dNP, float j, float l, float d) {
     super();
     pos = p; angle = a; noisePos = nP; dNoisePos = dNP;
     jitter = j; life = l; decay = d;
   }
   void newAngle() {
     noisePos.add(dNoisePos);
     angle += (noise(noisePos.x, noisePos.y) - 0.5) * jitter;
   } 
   void decay() {
     life -= decay;
     if(life <= 0) kill();
   }
   void setStroke() {
     stroke(0,0,0,life); 
   }
   void spawnNew() {
     if(random(1.0) > 0.96)
       new PerlinPen(pos, angle, noisePos, angleToVector(random(pi2), 0.01), -jitter*1.01, life, decay + 0.004);
   }
}

class MouseFollowPerlinPen extends PerlinPen {
  MouseFollowPerlinPen(PVector p, float a, PVector nP, PVector dNP, float j, float l, float d) {
    super(p,a,nP,dNP,j,l,d);
  }
  void newAngle() {
    //go towards mouse!
    angle = (float) Math.atan2(mouseY - pos.y, mouseX - pos.x);
  }
}



void setup() {
  size(800, 800);
  background(255,255,255);
  smooth();
  colorMode(RGB, 255, 255, 255, 1.0);
  pens.add(new PerlinPen(new PVector(400,400), 0, new PVector(0,0), new PVector(0.01,0),
                         0.1, 1.0, 0));
}

void draw() {
    println("mousepos" + mouseX);
    int n = pens.size(); //could get bigger
    for(int i = 0; i < n; i++) { ((Pen)pens.get(i)).move(); }
    for(int i = 0; i < kill.size(); i++) {
      pens.remove(kill.get(i));
    }
    kill.clear();    
}

void keyPressed() {
  save("dump"+hour()+minute()+second()+".png");
  println("Saved!");
}

