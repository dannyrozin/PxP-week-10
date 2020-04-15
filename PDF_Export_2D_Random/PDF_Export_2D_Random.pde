/* 
Creates a gradient made of random shapes
Press R to Export PDF
*/

import processing.pdf.*;
boolean record = false;


void setup()
{
  size(1000, 700);   
 
  fill(0);
  frameRate(1);
}

void draw()
{
  background(255);
  
   if (record == true) {
   beginRecord(PDF, "output.pdf");  // Start recording to the file
  }
  

  stroke(0);
 for (int x=0;x<width;x+=50){
    for (int y=0;y<height;y+=50){
      switch ((int)random(2)){
        case 0: 
        ellipse(x,y,random(x/30,x/20),random(x/30,x/20));
        break;
      
        case 1: 
         float rectWidth = random(x/30,x/20);
        float rectHeight = random(x/30,x/20);
        rect(x-rectWidth/2,y-rectHeight/2,rectWidth, rectHeight);
        break;
        
        
      }
    }
  }
  
  if (record == true) {
    endRecord();
    record = false; // Stop recording to the file
    println("recorded PDF");
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') { // Press R to save the file
    record = true;
  }
}
