
// The world pixel by pixel 2021
// Daniel Rozin
// Angles Mirror- a simulation of my mechanical piece of same name
// move mouse to set the threshold between forground and background
// uses Kinect 2 and uses the depth image -PXP methods in the bottom


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect2 kinect2;
int A, R, G, B;
void setup() {
  size(512, 424);                             // this is the size of the Kinect2 depth data (RGB is bigger)
  kinect2 = new Kinect2(this);
  kinect2.initDepth();                        // we will be using only the depth data
  kinect2.initDevice();                       // start the kinect
}

void draw() { 
  background(0);
  stroke(255, 255, 0);
  strokeWeight(2);
  int depthThreshold = mouseX;
  PImage depthImage = kinect2.getDepthImage();                // we will be using the depth image not the raw depth
  depthImage.loadPixels();                                    // it lives in a PImage so we need to load the pixels                                
  for (int x = 0; x<width; x+=15) {                           // skip every 15 pixels
    for (int y = 0; y<height; y+=15) {
      PxPGetPixel(x, y, depthImage.pixels, width);            // Get the RGB of each depth pixel as its gray the R,G,B are all the same
      int angle = 45;                                         
      if (R>0 && R <depthThreshold) angle = 135;               // if the depth is more than the threshold (brighter is farther away)
                                                                // rotate 135 degrees
      pushMatrix();
      translate(x, y);                                         
      rotate(radians(angle));                                
      line(0, 0, 18, 0);
      popMatrix();
    }
  }
}



void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to define the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
