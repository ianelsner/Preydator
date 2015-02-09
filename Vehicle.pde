// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// The "Vehicle" class (for wandering)

class Vehicle {
  PVector targeto;
  PVector location;
  PVector velocity;
  PVector acceleration;
  State state;
  int turnDirection;
  int avoidCount;
  color colour;
  float r;
  float wandertheta;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  Vehicle(float x, float y, char rgb) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    switch(rgb) {
      case 'r':
        colour = color(255,0,0);
        break;
      case 'g':
        colour = color(0,255,0);
        break;
      case 'b':
        colour = color(0,0,255);
        break;
      case 'y':
        colour = color(255,255,0);
        break;
      case 'c':
        colour = color(0,255,255);
        break;
      case 'm':
        colour = color(255,0,255);
        break;
    }
    avoidCount = 0;
    state = state.wander;
    r = 6;
    wandertheta = 0;
    maxspeed = 2;
    maxforce = 0.05;
  }

  void run() {
    update();
    borders();
    display();
  }
  
    

  // Method to update location
  void update() {
    
   //   acceleration = new PVector(0,0);
    // Update velocity
    
   // acceleration.mult((frameCount % 100)/5);
    velocity.add(acceleration);
   // velocity.add((frameCount % 100)/5);
  // velocity.mult(0.1);
   
   //println(velocity);
    // Limit speed
   // velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void wander() {
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 80;         // Distance for our "wander circle"
    float change = 0.3;


    // 90-degree turn velocity if colliding with wall or avoiding after collision
    if (state == state.collision) {
      velocity.rotate(turnDirection * maxRotation / backoffSteps);
    } else if (state == state.wander) {
      wandertheta += random(-change,change);     // Randomly change wander theta
    }
    
    // Now we have to calculate the new location to steer towards on the wander circle
    PVector circleloc = velocity.get();    // Start with velocity
    circleloc.normalize();            // Normalize to get heading
    circleloc.mult(wanderD);          // Multiply by distance
   
    circleloc.add(location);               // Make it relative to boid's location
    targeto = circleloc;
    float h = velocity.heading2D();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circleloc,circleOffSet);
    seek(target);

    // Render wandering circle, etc. 
    if (debug) drawWanderStuff(location,circleloc,target,wanderR);
  }  

  void applyForce(PVector force) {
    acceleration.add(force);
  }


  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    
  // desired.mult(0.01);
   
 //  println(desired);
   
   
    // Normalize desired and scale to maximum speed
    
   
    
    
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

    applyForce(steer);
  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(colour);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
   // arc(0,0,200,200, -20,20);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
    
  }
  
  
  void nextState(){
    // Get color of target pixel
    color buffering = buffer.get(int(targeto.x),int(targeto.y));

    // Make state decision based on color and current state
    if (state != state.collision && buffering == color(0,0,0)){
      state = state.collision;
      
      // Decide if he will resolve collision turning C or CC.
      turnDirection = ceil(random(-1,1));
      if (turnDirection == 0) {
        turnDirection = -1;
      }
      
      avoidCount = backoffSteps;
      fill(255,0,0);
    } else if (state == state.collision && avoidCount > 0 ) {
      avoidCount--;
    } else if (avoidCount == 0) {
      state = state.wander;
    }
    //rect(255,10, 10,10);
    
  }
  
}


// A method just to draw the circle associated with wandering
void drawWanderStuff(PVector location, PVector circle, PVector target, float rad) {
  stroke(0); 
  noFill();
  ellipseMode(CENTER);
  ellipse(circle.x,circle.y,rad*2,rad*2);
  ellipse(target.x,target.y,4,4);
  line(location.x,location.y,circle.x,circle.y);
  line(circle.x,circle.y,target.x,target.y);
}

