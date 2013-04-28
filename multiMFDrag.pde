Mover[] movers = new Mover[9];
PVector wind;
Liquid water;

void setup() {
  size(640, 360);
  for (int i = 0; i<movers.length; i++) {
    movers[i] = new Mover(random(6s, 10), random(width), random(height));
  }
  wind = new PVector(.5, 0);
  water = new Liquid(0, 2*height/3, width, height, 1);
}

void draw() {
  background(152, 251, 152);
  water.display();

  for (int i = 0; i<movers.length;i++) {   
    if (mousePressed) {
      movers[i].applyForce(wind);
    }
    if (movers[i].isInside(water)) {
      movers[i].drag(water);
    }

    float c = .05;
    PVector friction = movers[i].velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);
    float m = movers[i].mass;
    PVector gravity = new PVector (0, .1*m);
    movers[i].applyForce(friction);
    movers[i].applyForce(gravity);
    movers[i].update();
    movers[i].checkEdges();
    movers[i].display();
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  int buffer;
  float mass;

  Mover(float m, float x, float y) {
    buffer = 7;
    acceleration = new PVector(0, 0);
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    mass = m;
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    velocity.limit(8);
    acceleration.mult(0);
  }

  void display() {
    stroke(0);
    fill(200, 0, 0);
    ellipse(location.x, location.y, 20, 20);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x = velocity.x *-1;
    }
    else if (location.x < 0) {
      location.x = 0;
      velocity.x = velocity.x *-1;
    }
    if (location.y > height) {
      location.y = height;
      velocity.y = velocity.y *-1;
    }
    else if (location.y < 0) {
      location.y = 0;
      velocity.y = velocity.y *-1;
    }
  }
  boolean isInside(Liquid l) {
    if (location.x>l.x && location.x<l.x+l.w && location.y>l.y && location.y<l.y+l.h) {
      return true;
    }
    else {
      return false;
    }
  }
  void drag(Liquid l) {
    float speed = velocity.mag();
    float dragMag = l.c * speed * speed;
    PVector drag = velocity.get();
    drag.mult(-1);
    drag.normalize();
    drag.mult(dragMag);
    applyForce(drag);
  }
}
class Liquid {
  float x, y, w, h;
  float c;
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }
  void display() {
    noStroke();
    fill(0, 0, 128);
    rect(x, y, w, h);
  }
}

