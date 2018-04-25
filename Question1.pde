//Gabrielle Latreille, 6.18

ArrayList<Survivor> people = new ArrayList<Survivor>();

final float healthySpeed = 2, injuredSpeed=1, infectedSpeed=1.5;
float closestDist=width*height, speed, closestX=width, closestY=height;
int reinforced=0, humanLeft =0;

void setup() {
  size(800, 800);
  rectMode(CENTER);
  for (int i = 0; i< (int)random(50, 150); i++) {
    people.add(new Survivor(5));
  }
}

void draw() {
  if (!checkWinner()) {
    background(0);
    moveSurvivors();
    drawSurvivors();

    for (int i=0; i<people.size(); i++) {
      for (int j=0; j<people.size(); j++) {
        if (checkCollision(people.get(i), people.get(j)) && people.get(i).infected!=people.get(j).infected) { //check if an infected collides with a non-infected
          if (((people.get(i).injured || people.get(j).injured) && (int)random(0, 100) < 60) || 
            ((!people.get(i).injured || !people.get(j).injured) && (int)random(0, 100) < 30) ||
            (people.get(i).bullets==0 || people.get(j).bullets==0)) {
            people.get(i).infected = true;
            people.get(j).infected = true;
            people.get(i).injured = false;
            people.get(j).injured = false;
          } else {
            if (people.get(i).infected) {
              people.get(j).bullets --;
              people.remove(i);
            } else if (people.get(j).infected) {
              people.get(i).bullets --;
              people.remove(j);
            }
          }
        }
      }
    }
    reinforcement();
    for (int i = 0; i<people.size(); i++)
      checkSides(people.get(i));
    fill(0);
    text("Survivors left: "+survivorPrecentage(people)+"%", width-150, height-10);
    text("Total bullets left: "+survivorBullets(people), 20, height-10);
  }
}


boolean checkCollision(Survivor i, Survivor j) {
  if (dist(i.x, i.y, j.x, j.y) < i.size) {
    return true;
  } else {
    return false;
  }
}


void moveSurvivors() {

  for (int i=0; i<people.size(); i++) {
    closestDist = width*height;

    for (int j=i+1; j<people.size(); j++) {
      if (people.get(i).infected!=people.get(j).infected) {
        if (closestDist > dist(people.get(i).x, people.get(i).y, people.get(j).x, people.get(j).y)) {
          closestDist = dist(people.get(i).x, people.get(i).y, people.get(j).x, people.get(j).y);
          closestX = people.get(j).x;
          closestY = people.get(j).y;
        }
      }
    }

    if (people.get(i).infected) {
      speed = infectedSpeed;
    } else if (people.get(i).infected) {
      speed = injuredSpeed;
    } else {
      speed = healthySpeed;
    }

    float turnAngle = atan2(closestX - people.get(i).x, closestY - people.get(i).y);
    if (random(0, 100) <= 10) {
      if (people.get(i).infected) {
        people.get(i).direction += random(turnAngle-HALF_PI, turnAngle+HALF_PI); //go towards
      } else {
        people.get(i).direction -= random(turnAngle-HALF_PI, turnAngle+HALF_PI); //go away
      }
    }

    people.get(i).x += int(speed*sin(people.get(i).direction));
    people.get(i).y += int(speed*cos(people.get(i).direction));
  }
}



void drawSurvivors() {

  for (int i=0; i<people.size(); i++) {
    if (people.get(i).infected)
      fill(#32CD32, 175); //green
    else if (people.get(i).injured)
      fill(#FF7272, 175); //red
    else
      fill(#FAEBD7, 175); //beige

    ellipse(people.get(i).x, people.get(i).y, people.get(i).size, people.get(i).size);
    fill(0);
    text(people.get(i).name, people.get(i).x-11, people.get(i).y+5);
  }
}


//how much of humanity is surviving
int survivorPrecentage(ArrayList<Survivor> list) {
  float num=0;

  for (int i=0; i<list.size(); i++) {
    if (!list.get(i).infected) {
      num++;
    }
  }

  int percentage = int((num+humanLeft)/(people.size()+humanLeft)*100);
  return percentage;
}


//how many bullets are left in play
int survivorBullets(ArrayList<Survivor> list) {
  int bulletsLeft=0;

  for (int i=0; i<list.size(); i++) {
    if (!list.get(i).infected) {
      bulletsLeft+=list.get(i).bullets;
    }
  }

  return bulletsLeft;
}


void checkSides(Survivor item) {

  if (item.infected) {
    //stays in the window
    if (item.x-item.size/2<0)
      item.x = 0+item.size/2;
    else if (item.x+item.size/2>width)
      item.x = width-item.size/2;

    if (item.y-item.size/2<0)
      item.y = 0+item.size/2;
    else if (item.y+item.size/2>height)
      item.y = height-item.size/2;
  } else {
    //disappears
    if (item.x+item.size/2<0 || item.x-item.size/2>width) {
      people.remove(item);
      humanLeft++;
    }
    if (item.y+item.size/2<0 || item.y-item.size/2>height) {
      people.remove(item);
      humanLeft++;
    }
  }
}


boolean checkWinner() {
  for (int i=0; i<people.size(); i++) {
    if (!people.get(i).infected) {
      break;
    } else if (i==people.size()-1 && survivorPrecentage(people)<20) {
      noLoop();
      fill(#32CD32);
      rect(width/2, height/2, width, height);
      fill(0);
      text("Humanity is doomed. You lose...", width/2, height/2);
      return true;
    } else if (i==people.size()-1 && survivorPrecentage(people)>=20) {
      noLoop();
      fill(#FAEBD7);
      rect(width/2, height/2, width, height);
      fill(0);
      text("Humanity may survive yet. You win...for now.", width/2, height/2);
      return true;
    }
  }
  return false;
}


void reinforcement() {
  //Only call reinforcements 10 times. Humanity is almost gone. You don't have a limitless supply.
  if (survivorPrecentage(people)<20 && reinforced<=10) {
    reinforced++;
    people.add(new Survivor(0));
    people.add(new Survivor(0));
  }
}