Sequencer seq;
float bpm = 128;
float b = 0;
float smooth = .1;
float b0, b1, b2, b3;

void setup() {
  fullScreen();
  colorMode(HSB);
  frameRate(60);
  rectMode(CENTER);
  b0 = 0;
  b1 = 0;
  b2 = 0;
  b3 = 0;

  seq = new Sequencer(bpm, 4, 4, 4, "nigga");
}

void draw() {
  background(0);

  translate(width / 2, height / 2);

  fill(0, 255, b0);
  rect(-width / 4, -height / 4, width / 2, height / 2);
  fill(75, 255, b1);
  rect(width / 4, -height / 4, width / 2, height / 2);
  fill(150, 255, b2);
  rect(-width / 4, height / 4, width / 2, height / 2);
  fill(225, 255, b3);
  rect(width / 4, height / 4, width / 2, height / 2);

  seq.update();

  bg();
}

void keyPressed() {
  seq.control();
  switch(key) {
  case 't':
    b0 = 255;
    break;
  case 'y':
    b1 = 255;
    break;
  case 'g':
    b2 = 255;
    break;
  case 'h':
    b3 = 255;
    break;
  }
}

void mousePressed() {
  seq.mouseSelect();
}

void bg() {
  b0 = lerp(b0, 0, smooth);
  b1 = lerp(b1, 0, smooth); 
  b2 = lerp(b2, 0, smooth); 
  b3 = lerp(b3, 0, smooth); 
  if (seq.outAndChanged(0)) {
    b0 = 255;
  }
  if (seq.outAndChanged(1)) {
    b1 = 255;
  }
  if (seq.outAndChanged(2)) {
    b2 = 255;
  }
  if (seq.outAndChanged(3)) {
    b3 = 255;
  }
}

void nigga() {
  seq.metro.metroTrigger();
}
