
// The world pixel by pixel 2022
// Daniel Rozin
// green screen effect using distance to determine foregound and background
// move mouse to set the threshold between forground and background
// uses Kinect 2 and uses the depth image -PXP methods in the bottom


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect2 kinect2;

// Depth image
PImage secondImage;

int   minDistance= 100;

int A, R, G, B;
void setup() {
  size(512, 424);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initVideo();
  kinect2.initRegistered();
  kinect2.initDevice();
  secondImage = loadImage("http://www.planetware.com/photos-large/USNY/new-york-niagara-falls-state-park.jpg");
  secondImage.resize(width, height);
  secondImage.loadPixels();
  println(kinect2.depthWidth);
}



void draw() { 
  loadPixels();
  PImage videoImage= kinect2.getVideoImage();
  PImage depthImage = kinect2.getDepthImage();
  PImage registeredImage= kinect2.getRegisteredImage();
  registeredImage.resize(width, height);
  registeredImage.loadPixels();
  depthImage.loadPixels();
  int maxDistance= mouseX;
  for (int x=0; x < width; x++) {
    for (int y=0; y < height; y++) {
       PxPGetPixel(x, y, depthImage.pixels, width);                    // get the pixel values from the depth image
      if (R < maxDistance && R  > 0) {                                  // its gray so R the same as G and B
        PxPGetPixel(x, y, registeredImage.pixels, width);                // if the depth is less than our threshold
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);                  // then we set the RGB from the kinect RGB camera
      } else {
        PxPGetPixel(x, y, secondImage.pixels, width);                  // otherwise we get a pixel from our image
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);
      }
    }
  }
  updatePixels();
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
