class Light{
 float brightness;
 int hue;
 int sat;
 color col;
 
 
 Light(){
  brightness = 0;
  hue = 0;
  sat = 255;
  col = color(hue, sat, brightness);
 }
 
 void prime(){
   col = color(hue, sat, brightness);
  fill(col); 
 }
 
 void show(){
   sphere(100);
 }
 
 void update(){
  prime();
  show();
 }
 
 void fade(){
   lerp(this.brightness, 0, .3);
 }
 
 
}
