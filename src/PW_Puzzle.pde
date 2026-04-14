// Main class
Player player;
Wall wall;
Enemy enemy;
Item item;

void setup() {
  size(800, 300);

  player = new Player(50, 50);
  wall = new Wall(200, 150, 100, 50);
  enemy = new Enemy(300, 200);
  item = new Item(500, 200);
}

void draw() {
  background(30);

  wall.display();
  item.display();

  player.update();
  player.display();

  enemy.update();
  enemy.display();

  // simple interactions
  if (wall.collides(player.x, player.y)) {
    println("Player hit wall");
  }

  if (item.collected(player.x, player.y)) {
    println("Item collected!");
  }
}



class Player {
  float x, y;
  float speed = 2;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    if (keyPressed) {
      if (key == 'w') y -= speed;
      if (key == 's') y += speed;
      if (key == 'a') x -= speed;
      if (key == 'd') x += speed;
    }
  }

  void display() {
    fill(0, 200, 255);
    ellipse(x, y, 20, 20);
  }
}



class Wall {
  float x, y, w, h;

  Wall(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(150);
    rect(x, y, w, h);
  }

  boolean collides(float px, float py) {
    return (px > x && px < x + w &&
            py > y && py < y + h);
  }
}



class Enemy {
  float x, y;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    // simple movement (random wandering)
    x += random(-1, 1);
    y += random(-1, 1);
  }

  void display() {
    fill(255, 50, 50);
    ellipse(x, y, 20, 20);
  }
}


class Item {
  float x, y;
  boolean taken = false;

  Item(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    if (!taken) {
      fill(255, 255, 0);
      rect(x, y, 15, 15);
    }
  }

  boolean collected(float px, float py) {
    if (!taken && dist(px, py, x, y) < 15) {
      taken = true;
      return true;
    }
    return false;
  }
}
