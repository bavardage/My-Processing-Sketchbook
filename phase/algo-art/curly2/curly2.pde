
ArrayList pens = new ArrayList();
ArrayList kill = new ArrayList();


float pi2 = 2*(float)Math.PI; //precalculate this

void setup() {
  size(800, 800);
  background(255,255,255);
  smooth();
  colorMode(RGB, 255, 255, 255, 1.0);
  pens.add(new Loopy(new PVector(400,400), new PVector(0,0), new PVector(0.01, 0),
                      0, 0.05, 1.0, 0.0));
                 
}

class Loopy {
  PVector pos;
  PVector noisePos;
  PVector dNoisePos;
  
  float angle;
  float jitter;
  
  float life = 1.0;
  float decay = 0.0;
  
  Loopy(PVector posInit, PVector noisePosInit, PVector dNoisePosInit,
        float angleInit, float jitterInit,
        float lifeInit, float decayInit) {
    pos = posInit; noisePos = noisePosInit; dNoisePos = dNoisePosInit;
    angle = angleInit; jitter = jitterInit;
    life = lifeInit; decay = decayInit;
  }
 
  void move() {
    noisePos.add(dNoisePos);
    float dAngle = (noise(noisePos.x, noisePos.y) - 0.5) * jitter;
    angle += dAngle;
    
    //normalise the angle
    while(angle >= Math.PI) { angle -= pi2; };
    while(angle < -Math.PI) { angle += pi2; };
    
    life -= decay;
    if(life <= 0) die();
    
    float x2 = pos.x + (float) Math.cos(angle);
    float y2 = pos.y + (float) Math.sin(angle);
    
    stroke(0,0,0,life);
    line(pos.x, pos.y, x2, y2);
    pos.set(x2,y2,0); 
    
    //make more pens?
    if(-0.3 <= dAngle && dAngle < 0.3 && random(1.0) > 0.8) {
      pens.add(new Loopy(new PVector(pos.x, pos.y),
               new PVector(noisePos.x, noisePos.y), new PVector(random(-0.01, 0.01),
                                                                random(-0.01, 0.01)),
               angle, jitter * -5, life, decay + 0.01));
      println("NEW PEN MADE!");
    }
  } 
  
  void die() {
    kill.add(this);
  }
}

void draw() {
    int n = pens.size(); //could get bigger
    for(int i = 0; i < n; i++) { ((Loopy)pens.get(i)).move(); }
    for(int i = 0; i < kill.size(); i++) {
      pens.remove(kill.get(i));
    }
    kill.clear();    
}

void keyPressed() {
  save("dump"+hour()+minute()+second()+".png");
  println("Saved!");
}
