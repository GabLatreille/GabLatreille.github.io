class Survivor {
  int bullets;
  float x, y;
  boolean infected=false, injured=false;
  String name;
  final int size=25;
  float direction=0;

  Survivor(int percentage) {
    this.bullets = (int)random(0, 6);
    this.x = random(0+size/2, width-size/2);
    this.y = random(0+size/2, height-size/2);
    this.name = str((int)random(1000));
    if ((int)random(0, 100) < percentage)
      infected = true;
    else if ((int)random(0, 100) < 25)
      injured = true;
  }
}