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
  
  
  
  
  
  float[] xx = new float[50];
  float[] yy = new float[50];
  
   


  Vehicle(float x, float y, char rgb) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    
     for(int i = 0; i<xx.length; i++) {
    xx[i] = 0;
    yy[i] = 0;
  }
    
    
    
    
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
    float wanderD = 40;         // Distance for our "wander circle"
    float change = 0.3;
    
    
    
    
      for(int i = 0; i<xx.length-1; i++) {
    // and shift all the values down one item
    xx[i] = xx[i+1];
    yy[i] = yy[i+1];
     
    // set the fill colour to be darker the
    // lower its index in the array
    fill(i*2);
    // and draw the circle at the position
   // ellipse(xx[i], yy[i], i, i);
     
  }
   
  // set the last items in the array to match the mouse position
  xx[xx.length-1] = location.x;
  yy[yy.length-1] = location.y;
   




    // 90-degree turn velocity if colliding with wall or avoiding after collision
    if (state == state.collision) {
      
      
         PVector newvelocity = velocity.get(); 
    
    velocity.rotate(turnDirection * maxRotation / backoffSteps);
    
    newvelocity.rotate(turnDirection *180);
     newvelocity.normalize(); 
      PVector circleloc = velocity.get();    
         circleloc.normalize();            // Normalize to get heading
    circleloc.mult(wanderD);    
         float h = velocity.heading2D();   
         circleloc.add(location);        
      PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h),wanderR*sin(wandertheta+h));
    PVector target = PVector.add(circleloc,circleOffSet);
     
  // ellipse(target.x, target.y, 10, 10);
    
    
         circleloc.normalize(); 
     // PVector  target = PVector.add(circleloc.add(0,0),circleloc.add(0,0));
      wandertheta = 0;
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
     if (state == state.wander) {
    seek(target);
    }
    //PVector location = new PVector(0,0);
 //   rect(200,200, 200,200);
  // seek(location);


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
    
    
          PVector newvelocity = velocity.get(); 
    
   // velocity.rotate(turnDirection * maxRotation / backoffSteps);
    
 //   newvelocity.rotate(turnDirection);
     newvelocity.normalize(); 
      PVector circleloc = newvelocity.get();    
         circleloc.normalize();            // Normalize to get heading
    circleloc.mult(80);    
         float h = newvelocity.heading2D();   
         circleloc.add(location);        
      PVector circleOffSet = new PVector(25*cos(wandertheta+h),25*sin(wandertheta+h));
    PVector targetx = PVector.add(circleloc,circleOffSet);
     
  // ellipse(targetx.x, targetx.y, 10, 10);
    
    
    
     // PVector newnewvelocity = velocity.get(); 
      //newnewvelocity.normalize(); 
     // newnewvelocity.rotate(radians(180));
     
     
     
  color findo = buffer.get(int(xx[0]),int(yy[0]));
     
      fill(0,255,255);
      if (findo ==color(0,0,0)) {
      fill(255,0,0);
       color findoo = buffer.get(int(xx[49]),int(yy[49]));
      if (findoo !=color(0,0,0)) {
      
    float  hoverx = xx[49];
    float  hovery = yy[49];
      
      
      for(int i = 0; i < 49; i++){
        
        xx[i] = hoverx;
        yy[i] = hovery;
        }
      }
    
  
}
    //  println(newvelocity.heading2D());  
      
      
      
    //  targetx.mult(-1);
       ellipse(xx[0], yy[0], 10, 10);
    
    
    PVector newtarget = new PVector(xx[0], yy[0]);
    
    
    println(newtarget);
    
    
    
    
    
     if (state == state.collision) {
    
    seek(newtarget);
     }
    
    
    
    
    
    
    
    
    
    
    
    
    
    fill(255,0,0);
   // ellipse(lerp(location.x, targeto.x, .5), lerp(location.y, targeto.y, .5), 10,10);
    color buffering = buffer.get(int(targeto.x),int(targeto.y));
    color bufferingo = buffer.get(int(targeto.x),int(targeto.y));
    color buffering4 = buffer.get(int(targeto.x),int(targeto.y));
    color buffering2 = buffer.get(int(lerp(location.x, targeto.x, .5)),int(lerp(location.y, targeto.y, .5)));
    
    //rect(int(targeto.x)-25,int(targeto.y)-25, 50, 50);
    PImage buffering3 = buffer.get(int(targeto.x)-25,int(targeto.y)-25, 50, 50);
    
    
    
   
 //color buffering2 = buffer.get(int(lerp(location.x, targeto.x, .5)),int(lerp(location.y, targeto.y, .5)));

    // Make state decision based on color and current state
    if (state != state.collision && buffering == color(0,0,0)){
      state = state.collision;
      
      // Decide if he will resolve collision turning C or CC.
      turnDirection = ceil(random(-1,1));
      if (turnDirection == 0) {
        turnDirection = -1;
      }
      
      avoidCount = backoffSteps;
    } 
    
    else if (state == state.collision && avoidCount > 0 ) {
      avoidCount--;
      
      
      
    } 
    
    else if (state == state.collision && avoidCount < 1 && buffering4 == color(0,0,0)) {
    
    rect(200, 200, 200, 200);
    
    }
      else if (state == state.collision && avoidCount < 1 && buffering4 != color(0,0,0)) {
          state = state.wander;
    
      }
    
  //  if(state == state.collision && buffering == color(0,0,0)){
   //  avoidCount = 10;
      
      
      
  //    rect(10,10,10,10);
  // }
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

