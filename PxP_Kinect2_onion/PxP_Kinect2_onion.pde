// The world pixel by pixel 2020
// Daniel Rozin
// a black and white banding effect
// move mouseX to set the threshold between forground and background
// move mouseY to set the width of the bands
// uses Kinect 2 and uses the raw depth data -PXP methods in the bottom


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect2 kinect2;

int A, R, G, B;
void setup() {                                          // this is the size of the Kinect2 depth data (RGB is bigger)
  size(512, 424);
  kinect2 = new Kinect2(this);                           // using kinect 2 
  kinect2.initDepth();                                    // we will be using the depth
  kinect2.initDevice();
}

void draw() { 
  background(255);
  int depthThreshold = mouseX*10;
  int[] rawDepth = kinect2.getRawDepth();                    // get the raw depth data and place in an array of ints
  loadPixels();
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      int thisDepth= x+y*width;                                               // calculate where our pixel lives in the depth int array
      if (rawDepth[thisDepth]>0 && rawDepth[thisDepth] <depthThreshold) {       //check if we are closer than the theshold but not 0
        int bandWidth= mouseY;                                                    // the width of the bands, change this and see what happens
        if (rawDepth[thisDepth] % bandWidth > bandWidth/2) {                  // using modulus to make a repeating band and then thresholding in the middle of the band
          PxPSetPixel(x, y, 255, 255, 255, 255, pixels, width);
        } else {      
          PxPSetPixel(x, y, 0, 0, 0, 255, pixels, width);
        }
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
