
// GLOBALS

Player player;
Enemy enemy;
ArrayList<Wall> walls;

String gameState = "menu";

// smooth movement keys
boolean wPressed, aPressed, sPressed, dPressed;


// SETUP

void setup() {
  size(800, 400);
  initGame();
}

// reset / start game
void initGame() {
  player = new Player(50, 50);
  enemy = new Enemy(700, 300);

  walls = new ArrayList<Wall>();
  buildMaze();
}


// DRAW LOOP

void draw() {
  background(30);

  if (gameState.equals("menu")) {
    drawMenu();
  } else if (gameState.equals("game")) {
    runGame();
  } else if (gameState.equals("gameover")) {
    drawGameOver();
  }
}


// MENU

void drawMenu() {
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("PW_Puzzle", width/2, 120);

  drawButton(width/2 - 100, 200, 200, 60, "START");
}

void drawButton(float x, float y, float w, float h, String label) {
  boolean hover = mouseX > x && mouseX < x+w &&
                  mouseY > y && mouseY < y+h;

  fill(hover ? 100 : 70);
  rect(x, y, w, h, 10);

  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(label, x + w/2, y + h/2);
}


// GAME

void runGame() {

  // draw maze
  for (Wall w : walls) {
    w.display();
  }

  // update player
  player.update();
  player.display();

  // enemy
  enemy.update(player);
  enemy.display();

  // lose condition
  if (dist(player.x, player.y, enemy.x, enemy.y) < 15) {
    gameState = "gameover";
  }
}


// GAME OVER

void drawGameOver() {
  fill(255);
  textAlign(CENTER);
  textSize(32);
  text("Game Over", width/2, 150);

  drawButton(width/2 - 100, 220, 200, 60, "RESTART");
}


// MOUSE INPUT

void mousePressed() {

  // menu button
  if (gameState.equals("menu")) {
    if (overButton(width/2 - 100, 200, 200, 60)) {
      initGame();
      gameState = "game";
    }
  }

  // restart button
  if (gameState.equals("gameover")) {
    if (overButton(width/2 - 100, 220, 200, 60)) {
      initGame();
      gameState = "game";
    }
  }
}

boolean overButton(float x, float y, float w, float h) {
  return mouseX > x && mouseX < x+w &&
         mouseY > y && mouseY < y+h;
}


// KEY INPUT (SMOOTH WASD)

void keyPressed() {
  if (key == 'w') wPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'd') dPressed = true;
}

void keyReleased() {
  if (key == 'w') wPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'd') dPressed = false;
}


// MAZE

void buildMaze() {

  // borders
  walls.add(new Wall(0, 0, 800, 20));
  walls.add(new Wall(0, 380, 800, 20));
  walls.add(new Wall(0, 0, 20, 400));
  walls.add(new Wall(780, 0, 20, 400));

  // internal
  walls.add(new Wall(100, 80, 600, 20));
  walls.add(new Wall(100, 160, 20, 200));
  walls.add(new Wall(200, 160, 20, 200));
  walls.add(new Wall(300, 80, 20, 200));
  walls.add(new Wall(400, 160, 20, 200));
  walls.add(new Wall(500, 80, 20, 200));
  walls.add(new Wall(600, 160, 20, 200));
}


// PLAYER

class Player {
  float x, y;
  float speed = 2;
  float r = 10;

  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {

    float dx = 0;
    float dy = 0;

    if (wPressed) dy -= 1;
    if (sPressed) dy += 1;
    if (aPressed) dx -= 1;
    if (dPressed) dx += 1;

    float mag = sqrt(dx*dx + dy*dy);
    if (mag > 0) {
      dx /= mag;
      dy /= mag;
    }

    float newX = x + dx * speed;
    float newY = y + dy * speed;

    boolean canMove = true;
    for (Wall w : walls) {
      if (w.collides(newX, newY, r)) {
        canMove = false;
      }
    }

    if (canMove) {
      x = newX;
      y = newY;
    }
  }

  void display() {
    fill(0, 200, 255);
    ellipse(x, y, r*2, r*2);
  }
}


// ENEMY

class Enemy {
  float x, y;
  float speed = 1.3;
  float r = 10;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update(Player p) {

    float dx = p.x - x;
    float dy = p.y - y;
    float d = sqrt(dx*dx + dy*dy);

    if (d != 0) {
      dx /= d;
      dy /= d;
    }

    float newX = x + dx * speed;
    float newY = y + dy * speed;

    boolean canMove = true;
    for (Wall w : walls) {
      if (w.collides(newX, newY, r)) {
        canMove = false;
      }
    }

    if (canMove) {
      x = newX;
      y = newY;
    }
  }

  void display() {
    fill(255, 50, 50);
    ellipse(x, y, r*2, r*2);
  }
}


// WALL

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

  boolean collides(float px, float py, float r) {
    return (px + r > x && px - r < x + w &&
            py + r > y && py - r < y + h);
  }
}
