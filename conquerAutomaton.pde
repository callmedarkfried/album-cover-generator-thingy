 
Board b;
int count = 0;
void setup() {
 size(1000, 1000);
 background(0);
 colorMode(RGB, 255);
 b = new Board(500, 500);
 strokeWeight(0);
 b.drawBoard();
 // This sets a sort of test pattern, remove if you want to draw yourself.
  b.frame();
 frameRate(60);
 
}

void draw() {
  
  
  // Remove this if you enjoy a black screen
  b.drawBoard(); 
 

 // Remove this if you DON'T want to draw. Useful to see the test pattern without having to recalculate every cell each frame
 if (frameCount == 1) {
   noLoop();
 }
}

void mousePressed() {
  int tileSize[] = {width / b.getSize()[0], height / b.getSize()[1]};
  if (mouseButton == RIGHT) {
    if (keyPressed) {
      save(count + ".png");
      count++;
    } else {
      b.addTile(mouseX/tileSize[0], mouseY/tileSize[1], 0);
    }
  } else if (mouseButton == LEFT) {
    if (keyPressed) {
      b.addTile(mouseX/tileSize[0], mouseY/tileSize[1], 2);
    } else {
      b.addTile(mouseX/tileSize[0], mouseY/tileSize[1], 1);
    }
  }
}
