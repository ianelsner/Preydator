
ArrayList<Vehicle> predators;
ArrayList<Vehicle> prey;
boolean debug = true;
PGraphics buffer;
PImage bufferimage;

// Setup parameters
int numPredators = 100;
int numPrey = 100;
int trailPts = 50;
float maxRotation = radians(180);

void setup() {
 
  // Set up map
  size(640,360);
  buffer = createGraphics(width, height);
  bufferimage = loadImage("Devide_Texture_2.png");
  
  // Initialize all of the vehicles
  predators = new ArrayList<Vehicle>();
  for (int i = 0 ; i < numPredators ; i++) {
    predators.add(new Vehicle(width/4, height/2, 'r'));
  }
  prey = new ArrayList<Vehicle>();
  for (int i = 0 ; i < numPrey ; i++) {
    prey.add(new Vehicle(width*3/4, height/2, 'g'));
  }
 
}

void draw() {
   
  // Prepare the map
  buffer.beginDraw();
  buffer.background(bufferimage);
  buffer.fill(0,0,0);
  buffer.ellipse(mouseX, mouseY, 50,50);
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


