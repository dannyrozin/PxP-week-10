
// The world pixel by pixel 2021
// Daniel Rozin
// green screen effect using distance to determine foregound and background
// move mouse to set the threshold between forground and background
// uses Kinect 2 and uses the raw depth data -PXP methods in the bottom


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect2 kinect2;

PImage secondImage;                       // this will hold our background image


int A, R, G, B;
void setup() {
  size(512, 424);                          // this is the size of the Kinect2 depth data (RGB is bigger)
  kinect2 = new Kinect2(this);            // using kinect 2 
  kinect2.initDepth();                    // we will be using the depth
  kinect2.initRegistered();              // we want the RGB image to be alligned to the depth 
  kinect2.initDevice();
  secondImage = loadImage("http://www.planetware.com/photos-large/USNY/new-york-niagara-falls-state-park.jpg");
  secondImage.resize(width, height);
  secondImage.loadPixels();
}

void draw() { 
  loadPixels();
  PImage registeredImage= kinect2.getRegisteredImage();           // get the registered RGB image and place in a PIMage
  registeredImage.loadPixels();                                   // load the pixels of the registered image so we can access its pixels
 int maxDistance= mouseX*10;
  int[] rawDepth = kinect2.getRawDepth();                         // get the raw depth data and place in an array of ints
  for (int x=0; x < width; x++) {
    for (int y=0; y < height; y++) {
      int thisDepth= x+y*width;                                   // calculate where our pixel lives in the depth int array
      if (rawDepth[thisDepth] < maxDistance && rawDepth[thisDepth]  > 0) {        //check if we are closer than the theshold but not 0
        PxPGetPixel(x, y, registeredImage.pixels, width);                         // if we are closer then copy the pixel from the RGB image to the screen
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);
      } else {
        PxPGetPixel(x, y, secondImage.pixels, width);                             // if we are further away than threshold then copy the pixel from the second image
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
