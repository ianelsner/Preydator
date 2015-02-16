
ArrayList<Vehicle> predators;
ArrayList<Vehicle> prey;
boolean debug = true;
PGraphics buffer;
PImage bufferimage;

// Setup parameters
int numPredators = 10;
int numPrey = 10;
int backoffSteps = 25;
float maxRotation = radians(180);

void setup() {
 
  size(640,360);
  
   buffer = createGraphics(width, height);
  predators = new ArrayList<Vehicle>();
  
  
  bufferimage = loadImage("Devide_Texture_2.png");
  
  
  for (int i = 0 ; i < numPredators ; i++) {
    predators.add(new Vehicle(width/2, height/2, 'r'));
  }
  prey = new ArrayList<Vehicle>();
  for (int i = 0 ; i < numPrey ; i++) {
    prey.add(new Vehicle(width/2, height/2, 'g'));
  }
 
}

void draw() {
   

  
 
   buffer.beginDraw();
  buffer.background(bufferimage);
   buffer.fill(0,0,0);
   buffer.ellipse(mouseX, mouseY, 500,500);
   
   buffer.endDraw();
   
   
    background(buffer);
  // Display, update, and check obstacle of each predator and prey
  for (int i = 0; i < predators.size() ; i++) {
    predators.get(i).wander();
    predators.get(i).run();
    predators.get(i).nextState();
  }
  for (int i = 0; i < predators.size() ; i++) {
    prey.get(i).wander();
    prey.get(i).run();
    prey.get(i).nextState();
  }
}

void mousePressed() {
  debug = !debug;
}


