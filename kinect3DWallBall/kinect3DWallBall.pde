import ddf.minim.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;
Ball b;
Paddle p;
PVector v;
boolean resetSwitch = true;
Minim minim;
AudioSnippet boing;

void setup() {
  size(800, 800, P3D);
  Minim minim = new Minim(this);
  boing = minim.loadSnippet("button-10.wav");
  PVector pos_init = new PVector(width/2, height/2, -300);
  PVector vel_init = new PVector(random(-10, 10), random(-8, 8), random(-10, 10));  
  b = new Ball(pos_init, vel_init); 
  p = new Paddle(new PVector(width/2, 9*height/10), 150); 

  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableUser( SimpleOpenNI.SKEL_PROFILE_ALL);

  
  stroke(0);
  strokeWeight(1);
  sphereDetail(8);
}

void draw() {
  kinect.update();   
  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  for ( int i = 0; i < userList.size(); i++ )
  {
    int userId = userList.get(i);
    if ( kinect.isTrackingSkeleton( userId) ) {
      PVector leftHand = new PVector();
      PVector rightHand = new PVector();

      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);

      background(200);

      spotLight(255, 255, 255, 0, 0, 100, 1, 1, -1, PI, 2);
      spotLight(255, 255, 255, width, 0, 100, -1, 1, -1, PI, 2);

      b.move();

      //If the ball is inbounds, display it.
      if (b.pos.z < 0) {
        b.display();
      }


      p.pos.x = width - rightHand.x;
      p.pos.y = width - rightHand.y;     
      p.pos.z = map(rightHand.z, 3000, 2700, 0, -200);
      p.pos.z = constrain(p.pos.z, 0, -200); 
     
      p.update();
     
      p.display();


      if (leftHand.y > height/2 && (resetSwitch == true)) {
        reset();
        resetSwitch = false;
      }

      if (leftHand.y < height/2) {
        resetSwitch = true;
      }

      //Room outline
      stroke(0);
      line(    0, 0, 0, 0, 0, -width);
      line(    0, width, 0, 0, width, -width);
      line(width, width, 0, width, width, -width); 
      line(width, 0, 0, width, 0, -width);

      line(    0, 0, -width, 0, width, -width);
      line(    0, width, -width, width, width, -width); 
      line(width, width, -width, width, 0, -width); 
      line(width, 0, -width, 0, 0, -width);
    }
  }
}

void onNewUser( int userId) // local variable userId
{
  println("start detection");
  kinect.startPoseDetection("Psi", userId);
}

void onStartPose(String pose, int userId) 
{
  println("started posed for user");
  kinect.stopPoseDetection(userId);
  kinect.requestCalibrationSkeleton(userId, true);
}

void onEndCalibration(int userId, boolean succesful)
// successful is a boolean variable that returns true or false
{
  if (succesful) {
    kinect.startTrackingSkeleton(userId);
    println("Successful!!");
  }
  else kinect.startPoseDetection("Psi", userId);
}

void reset() {
  background(200);
  b.pos.x = width/2;
  b.pos.y = height/2;
  b.pos.z = -width/2;
  b.vel.x = random(-10, 10);
  b.vel.y = random(-8, 8);
  b.vel.z = random(-11, 11);
}

public void stop() {
  boing.close();
  super.stop();
}

