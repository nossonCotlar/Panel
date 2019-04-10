class Metronome {
  float bpm;
  int speed;
  int minute = 60000;
  float interval;
  double time;
  double t;
  boolean trigger;

  Metronome(float bpm, int speed, String thread) {
    this.bpm = bpm;
    this.speed = speed;
    interval =  minute / bpm / speed;
    time = millis();
    trigger = false;

    thread(thread);
  }

  boolean metro() {
    t = millis();
    if (t - time > interval) {
      time = t;
      return true;
    }
    return false;
  }
  
  void setBpm(float x){
   bpm = x;
   interval = minute / bpm / speed;
  }
  
  void setSpeed(int x){
    if(x == 0) return;
     speed = x;
     interval = minute / bpm / speed;
  }

  void metroTrigger() {
    while (true) {
      if (metro()) {
        trigger = !trigger;
      }
      delay(1);
    }
  }
}
