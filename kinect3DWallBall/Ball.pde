class Ball {
  PVector pos;
  PVector vel;
  int r;
  int c;
  float acceleration;
  boolean in = true;

  Ball(PVector pos_, PVector vel_) {
    pos = pos_;
    vel = vel_;
    c = 255;
    r = 50;
    acceleration = .2;
  }

  void move() {
    if ((pos.x-r) < 0 || (pos.x+r) > width && (in == true)) {
       boing.play();
      boing.rewind();
      vel.x = -vel.x;
      in = false;
    }
    if ((pos.y-r) < 0 || (pos.y+r) > width && (in == true )) {
      boing.play();
      boing.rewind();
      vel.y = -vel.y;     
      in = false;
    }
    if ((pos.z-r) < -width && (in == true)) {
      boing.play();
      boing.rewind();
      vel.z = -vel.z;
      in = false;
      
    }
    else if ( (pos.x-r > 0) && (pos.x+r < width) && (pos.y-r > 0) && (pos.y+r < width) && (pos.z-r > -width) && (pos.z+r < 0)) {
      in = true;
    }

    paddleCheck(p);
    vel.y = vel.y + acceleration;
    pos = PVector.add(pos, vel);
  }

  void paddleCheck(Paddle p) {
    if (  (p.posInterp.z - pos.z) <= r && ( (pos.x - p.posInterp.x)*(pos.x - p.posInterp.x) + (pos.y -p.posInterp.y)*(pos.y-p.posInterp.y)  ) < (p.r)*(p.r)  ) {
      vel.z = -vel.z + 2*(p.pos.z - p.posP.z);
      vel.y = vel.y + 2*(p.pos.y - p.posP.y);
      vel.x = vel.x + 2*(p.pos.x - p.posP.x);
      boing.play();
      boing.rewind();
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    c = int(  map(-pos.z, 0, width, 0, 255)  );
    fill(c, 255-c, 0);
    noStroke();
    sphere(r);
    popMatrix();
  }
}

