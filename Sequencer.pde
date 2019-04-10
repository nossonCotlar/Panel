/*
o/p ==> nudging 
n/m ==> BPM down/up
,/. ==> BPM down/up (incrimental)
z/x ==> step count -/+
UP/DOWN ==> change channel
1, 2, 3, 4, 8 ==> set code sequence 
0 ==> clears current active channel
- ==> clear all code channels 
SPACE ==> jump to first state
*/ 

class Sequencer {
  Metronome metro;
  boolean[] state;
  boolean[] code; 
  boolean[][] channel;
  int channels;
  color onCol, offCol, activeCol, barCol;
  int steps;
  int big = 40;
  int offset = 10;
  int currentStep;
  int currentChannel;
  
  int prev;


  Sequencer(float bpm, int steps, int speed, int chan, String thread) {
    metro = new Metronome(bpm, speed, thread); 
    channels = chan;
    onCol = color(0, 255, 255);
    activeCol = color(100, 255, 255);
    offCol = 100;
    barCol = 70;
    this.steps = steps;
    state = new boolean[steps];
    code = new boolean[steps];
    channel = new boolean[channels][steps];
    currentStep = 0;
    currentChannel = 0;
    prev = -1;
    
    

    state[0] = true;
    for (int i = 1; i < steps; i++) {
      state[i] = false;
    }
    codeClear();
  }

  void update() {
    updateCurrent();
    printBpm();
    next();
    show(0);
  }

  boolean out(int chan) {
    return channel[chan][currentStep];
    
  }

  void show(int where) {
    //display active-control channel
    fill(activeCol);
    rect(-25, where + (currentChannel * (big + offset)), (big + offset) * steps + offset * 2, big + offset, 10);

    for (int j = 0; j < channels; j++) {
      for (int i = 0; i < steps; i++) { //display active and inactive steps
        if (state[i]) fill(onCol);
        else if (i % 4 == 0) fill(barCol);
        else fill(offCol);
        rect(i * (big + offset) - (steps / 2 * (big + offset)), where + (j * (big + offset)), big, big, 6);
      }
      fill(0);
      for (int i = 0; i < steps; i++) { //display coded steps
        if (channel[j][i])
          circle(i * (big + offset) - (steps / 2 * (big + offset)), where + (j * (big + offset)), big / 3);
      }
    }
  }

  void reset() {
    state[currentStep] = false;
    state[0] = true;
    currentStep = 0;
  }

  void next() {
    if (metro.trigger) {
      metro.trigger = !metro.trigger;
      if (currentStep == steps - 1) {
        currentStep = 0;
        state[steps - 1] = false;
        state[0] = true;
        return;
      }
      state[currentStep] = false;
      state[++currentStep] = true;
    }
  }

  void setBpm(float x) {
    metro.setBpm(x);
  }

  void setSpeed(int x) {
    metro.setSpeed(x);
  }

  void control() {
    if (keyPressed) {
      switch(key) {
      case ' ':
        reset();
        break;
      case 'x':
        setSpeed(metro.speed + 1);
        break;
      case 'z':
        setSpeed(metro.speed - 1);
        break;
      case 'm':
        setBpm(metro.bpm + 1);
        break;
      case 'n':
        setBpm(metro.bpm - 1);
        break;
        case '.':
        setBpm(metro.bpm + .1);
        break;
      case ',':
        setBpm(metro.bpm - .1);
        break;
      case 'p':
        nudgeF();
        break;
      case 'o':
        nudgeB();
        break;
      case '1':
        codeN(1);
        break;
      case '2':
        codeN(2);
        break;
      case '3':
        codeN(3);
        break;
      case '4':
        codeN(4);
        break;
      case '8':
        codeN(8);
        break;
      case '0':
        codeClear();
        break;
        case '-':
        codeClearAll();
        break;
      }
      switch(keyCode) {
      case UP:
        activeChannelUp();
        break;
      case DOWN:
        activeChannelDown();
        break;
      }
    }
  }

  void printBpm() {
    pushStyle();
    fill(255);
    textSize(50); 
    text(metro.bpm, -width/2 + 30, -height/2 + 60);
  }

  void mouseSelect() {
    int t = (mouseY   - 20 -  height / 2 + (channels * (big + offset) / 2)) / (big + offset) - 1;
    if (t >= 0 && t <= channels - 1) {
      currentChannel = t;
      setCode();
    }
  }

  void setCode() {
    //calculate which step the mouse is over
    int t = (mouseX  + 20 -  width / 2 + (steps * (big + offset) / 2)) / (big + offset);
    if (t >= 0 && t <= steps - 1) {
      channel[currentChannel][t] = !channel[currentChannel][t];
    }
  }

  void updateCurrent() {
    prev = seq.currentStep;
  }

  boolean currentChange() {
    return (currentStep != prev);
  }

  boolean outAndChanged(int chan) {
    return (out(chan) && currentChange());
  }

  void codeN(int n) {
    for (int i = 0; i < steps; i++) {
      if (i % n == 0) channel[currentChannel][i] = true;
      else channel[currentChannel][i] = false;
    }
  }

  void codeClear() {
    for (int i = 0; i < steps; i++) {
      channel[currentChannel][i] = false;
    }
  }

  void codeClearAll() {
    for (int j = 0; j < channels; j++) {
      for (int i = 0; i < steps; i++) {
        channel[j][i] = false;
      }
    }
  }

  void nudgeF() {
    metro.time += 100;
  }

  void nudgeB() {
    metro.time -= 100;
  }


  void activeChannelDown() {
    if (currentChannel < channels - 1)
      currentChannel++;
  }

  void activeChannelUp() {
    if (currentChannel > 0)
      currentChannel--;
  }
}
