
Vehicle wanderer;
boolean debug = true;
PImage buffer;

void setup() {
  size(640,360);
  wanderer = new Vehicle(width/2,height/2);
    
 buffer = loadImage("Devide_Texture.png");
}

void draw() {
  background(buffer);
  wanderer.wander();
  wanderer.run();
  wanderer.obsticle();
}

void mousePressed() {
  debug = !debug;
}


