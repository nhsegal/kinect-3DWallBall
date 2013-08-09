class Paddle {
  PVector pos, posP, posInterp;
  int r;

  Paddle(PVector pos_, int r_) {
    pos = pos_;
    posP = pos_;
    posInterp = pos_;
    r = r_;
  }

  void display() {
    pushMatrix();
    noStroke();
    fill(100, 100);
    translate(posInterp.x, posInterp.y, posInterp.z);
    ellipse(0, 0, r, r);
    popMatrix();
  }
  
  void update(){
    posP = new PVector(pos.x, pos.y, pos.z);
    posInterp = PVector.lerp(pos, posP, 0.5);
  }
}

