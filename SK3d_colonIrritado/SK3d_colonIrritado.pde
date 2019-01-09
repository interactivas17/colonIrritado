/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 3D Skeleton.
 Some features a not implemented, such as orientation
 */

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;


float zVal = 500;
//float rotX = PI;

float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
float zoomF = 700;

// the data from openni comes upside down
float rotY = radians(0);

PShape org3D;

PVector p0, p1, p2, dV, vArbi;

float rotateOrg = 0;

void setup() {

  p0 = new PVector(0, 0, 0);
  p1 = new PVector(1, 0, 0);
  p2 = new PVector(0, 1, 0);
  vArbi = new PVector(1, 1, 1);

  size(1024, 768, P3D);

  kinect = new KinectPV2(this);

  kinect.enableColorImg(true);

  //enable 3d  with (x,y,z) position
  kinect.enableSkeleton3DMap(true);

  kinect.init();

  org3D = loadShape("hepatitis.obj");
  ambientLight(102, 102, 102);
}

void draw() {
  background(0);

  image(kinect.getColorImage(), 0, 0, 320, 240);

  //translate the scene to the center 
  pushMatrix();
  translate(width/2, height/2, 0);
  //scale(zVal);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);


  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      float dist;
      PVector p1 = new PVector(joints[KinectPV2.JointType_SpineShoulder].getX(), joints[KinectPV2.JointType_SpineShoulder].getY());
      PVector p2 = new PVector(joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY());

      int tamaX, tamaY;

      pushMatrix();
      dist = PVector.dist(p1, p2);
      tamaX = int(dist/1.8);
      tamaY = int(dist/1.8);
      translate(joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY(), joints[KinectPV2.JointType_SpineBase].getZ());
      //sphere(0.05);
      scale(0.005);
      rotateY(rotateOrg);
      shape(org3D);//, joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY(), joints[jointType].getZ()/10, joints[jointType].getZ()/10);
      //ellipse(0, 0, 0.005, 0.005);

      popMatrix();


      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);

      //Draw body
      color col  = skeleton.getIndexColor();
      stroke(col);
      drawBody(joints);
    }
  }
  popMatrix();



  fill(255, 0, 0);
  text(frameRate, 50, 50);
}


void drawBody(KJoint[] joints) {

  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

  // Right Arm
  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

  // Left Arm
  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

  // Right Leg
  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

  // Left Leg
  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
  drawJoint(joints, KinectPV2.JointType_HandTipRight);
  drawJoint(joints, KinectPV2.JointType_FootLeft);
  drawJoint(joints, KinectPV2.JointType_FootRight);

  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
  drawJoint(joints, KinectPV2.JointType_ThumbRight);

  drawJoint(joints, KinectPV2.JointType_Head);
}

void drawJoint(KJoint[] joints, int jointType) {
  //int tamaX, tamaY;
  //strokeWeight(0.05f);
  ////strokeWeight(2.0f + joints[jointType].getZ()*8);
  //point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  //translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  //sphere(100);

   // dick vector
  p0.set(joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ());
  p1.set(joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ());
  p2.set(joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY(), joints[KinectPV2.JointType_SpineBase].getZ());
  dV = PVector.cross(PVector.sub(p1, p0, null), PVector.sub(p2, p0, null), null);
  dV.normalize();
  float a = PVector.angleBetween(dV, vArbi);
  rotateOrg = a;
  println(degrees(a));
  
  noStroke();
  beginShape();
  vertex(joints[KinectPV2.JointType_ShoulderLeft].getX(), joints[KinectPV2.JointType_ShoulderLeft].getY(), joints[KinectPV2.JointType_ShoulderLeft].getZ());
  vertex(joints[KinectPV2.JointType_ShoulderRight].getX(), joints[KinectPV2.JointType_ShoulderRight].getY(), joints[KinectPV2.JointType_ShoulderRight].getZ());
  vertex(joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY(), joints[KinectPV2.JointType_SpineBase].getZ());
  endShape();

  pushMatrix();
  noStroke();
  lights();
  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  sphere(0.05);
  //scale(0.005);
  //shape(org3D);//, joints[KinectPV2.JointType_SpineBase].getX(), joints[KinectPV2.JointType_SpineBase].getY(), joints[jointType].getZ()/10, joints[jointType].getZ()/10);
  //ellipse(0, 0, 0.005, 0.005);
  popMatrix();
}

void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  //strokeWeight(2.0f + joints[jointType1].getZ()*8);
  strokeWeight(0.005f);
  point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  point(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  //line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  /*pushMatrix();
   translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
   ellipse(0, 0, 25, 25);
   popMatrix();
   line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
   */
}

void drawHandState(KJoint joint) {
  handState(joint.getState());
  strokeWeight(0.05f);
  point(joint.getX(), joint.getY(), joint.getZ());
}

void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    stroke(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    stroke(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    stroke(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    stroke(100, 100, 100);
    break;
  }
}

void keyPressed()
{
  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if (keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if (keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if (zoomF < 0.01)
        zoomF = 0.01;
    } else
      rotX -= 0.1f;
    break;
  }
}