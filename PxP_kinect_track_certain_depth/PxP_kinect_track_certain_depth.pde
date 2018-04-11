// The world pixel by pixel 2018
// Daniel Rozin
// track objects that are in a certain distance from the camera 
// uses Kinect 2 and uses the  depth image -PXP methods in the bottom
// this is the simplest code, see Dan Shiffman's example AveragePointTracking2 for a much better tracking example

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect2 kinect2;

int depthToTrack = 40;
int A, R, G, B;
void setup() {
  size(512, 424);
  kinect2 = new Kinect2(this);            // We are only using the depth info, no video
  kinect2.initDepth();
  kinect2.initDevice();
  fill(255,255,0);
}

void draw() { 
  PImage depthImage = kinect2.getDepthImage();          // get the depth info i the form of a PImage
  image(depthImage, 0, 0);                              // draw the depth image to the screen
  depthImage.loadPixels();
  int sumX=0, sumY=0;                              //these wil sum the location of the pixels that qualify 
  int countGoodPixels=0;                            // this will count the pixels that qualify
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, depthImage.pixels, width);          // Get the RGB of each pixel
      int similarity=abs(R-depthToTrack);                   //R is enough as it is gray image
      if (similarity< 5) {                                  // if our pixel is within 5 values of the desied depth
        sumX += x;                                    // add the x and y to the sum variables
        sumY += y;
        countGoodPixels++;                            // count the pixels that qualify
      }
    }
  }
  if (countGoodPixels > 5) {                        // if less than 5 pixels qualified its probably just noise, so ignore
    int averageX = sumX/countGoodPixels;
    int averageY = sumY/countGoodPixels;
    ellipse( averageX, averageY, 15, 15);        // when we are done with all pixels the the best pixel is recordHolder
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