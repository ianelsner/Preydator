
ArrayList<Vehicle> predators;
ArrayList<Vehicle> prey;
boolean debug = true;
PImage buffer;
// Setup parameters
int numPredators = 1;
int numPrey = 1;
int backoffSteps = 25;
float maxRotation = 2.8;

void setup() {
 
  size(640,360);
  predators = new ArrayList<Vehicle>();
  for (int i = 0 ; i < numPredators ; i++) {
    predators.add(new Vehicle(width/2, height/2, 'r'));
  }
  prey = new ArrayList<Vehicle>();
  for (int i = 0 ; i < numPrey ; i++) {
    prey.add(new Vehicle(width/2, height/2, 'g'));
  }
    
 buffer = loadImage("Devide_Texture_2.png");
}

void draw() {
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


