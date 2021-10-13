import java.util.ArrayList; //<>//
public class Board {
  private BoardElement[][] board;
  private int currentScale = 10;
  
  private PImage scales;
  
  PVector[] bp = {new PVector(3, 6), new PVector(10, 25), new PVector(40, 30)};
  Bot[] b = {new Bot(color(255, 0, 0), bp[0]), new Bot(color(0, 255, 0), bp[1]), new Bot(color(0, 0, 255), bp[2])};
  //  Bot[] b = {new Bot(color(255,164,0), bp[0])};
  PVector b1p = new PVector(3, 6);
  Bot b1 = new Bot(color(0, 255, 0), bp[0]);
  PVector b2p = new PVector(10, 25);
  Bot b2 = new Bot(color(0, 0, 255), bp[1]);

  Board (int sizeX, int sizeY) {
    colorMode(RGB, 255);
    color c = color(0);
    
    
    board = new BoardElement[sizeX][sizeY];
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        PVector p = new PVector(x, y, 0);
        board[x][y] = new Cell(c, p, b, board.length, board[x].length);
      }
    }

    //for (int i = 0; i < 12; i++) {
    //  board[(int) (i*i*i / 10.648)][125].setOwner(b[1]);
    //  board[249 - (int) (i*i*i / 10.648)][125].setOwner(b[1]);
    //  board[125][(int) (i*i*i / 10.648)].setOwner(b[0]);
    //  board[125][249 - (int) (i*i*i / 10.648)].setOwner(b[0]);
    //}
  }

  Board (int sizeX, int sizeY, boolean testPattern) {
    colorMode(RGB, 255);
    color c = color(0);
    
    scales = loadImage("flame.png");
    scales.loadPixels();
    
    board = new BoardElement[sizeX][sizeY];
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        PVector p = new PVector(x, y, 0);
        //float col = (255 - brightness(scales.pixels[y*scales.width + x])) / 200;
        board[x][y] = new Cell(c, p, b, board.length, board[x].length);
      }
    }

    //for (int i = 0; i < 12; i++) {
    //  board[(int) (i*i*i / 10.648)][125].setOwner(b[1]);
    //  board[249 - (int) (i*i*i / 10.648)][125].setOwner(b[1]);
    //  board[125][(int) (i*i*i / 10.648)].setOwner(b[0]);
    //  board[125][249 - (int) (i*i*i / 10.648)].setOwner(b[0]);
    //}
    if (testPattern) {
      frame();
    }
  }

  public int[] getSize() {
    int[] s = {board.length, board[0].length};
    return s;
  }

  public void addTile(int x, int y, int i) {
    board[x][y].setOwner(b[i]);
  }
  
  public void img() {
    clearOwners();
    PImage img = loadImage("ooer.png");
    img.loadPixels();
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
        color c = img.get(x, y);
        if (red(c) > 200.0) {
          ((Cell) board[x][y]).setOwner(b[0]);
        }
        if (green(c) > 200.0) {
          ((Cell) board[x][y]).setOwner(b[1]);
        }
        if (blue(c) > 200.0) {
          ((Cell) board[x][y]).setOwner(b[2]);
        }
      }
    }
    println("image");
    drawBoard();
  }
  
  public void exportScalingMap() {
    PImage scales = createImage(board.length, board[0].length, RGB);
    scales.loadPixels();
    
    float max = 0;
    for (int i = 0; i < scales.pixels.length; i++) {
      max = max(max, ((Cell)board[i / board.length][i % board[0].length]).getScale());
    };
    max = max(20, max);
    float fac = 255.0 / max;
    
    println(max);
    for(int x = 0; x < board.length; x++) {
      for(int y = 0; y < board[x].length; y++) {
        scales.pixels[x + y*board[x].length] = color(min((int) (((Cell)board[x][y]).getScale() * fac), 255));
      }
    }
    scales.updatePixels();
    String timeString = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + "-" + millis() + ".png";
    scales.save("/exports/" + timeString);
  }
  
  public void spiral(float angle) {
    float step = 12;
    float anglestep = 12;
    int count = 0;
    //
    for (float r = 0.0; r < sqrt(board.length*board.length + board[0].length*board[0].length); r += step) {
      
      int x = (int) (r * cos(radians(angle + anglestep / 3)));
      int y = (int) (r * sin(radians(angle + anglestep / 3)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[0]);
        count++;
      }
      
      x = (int) ((r + 10) * cos(radians(angle)));
      y = (int) ((r +10) * sin(radians(angle)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[1]);
        count++;
      }
      
      x = (int) ((r +20) * cos(radians(angle - anglestep / 3)));
      y = (int) ((r +20) * sin(radians(angle - anglestep / 3)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[2]);
        count++;
      }
      angle -= anglestep;
      
    }
    println("spiral done", count);
    
  }
  
  public void frame() {
    clearOwners();
    int numberOfDots = 36;
   
    for (float i = 0; i < numberOfDots; i++) {
      int r = int(board.length * 0.65 / 2);
      int x = (int) (r * cos(radians(360.0/numberOfDots*i)));
      int y = (int) (r * sin(radians(360.0/numberOfDots*i)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[0]);
      }
      r = int(board.length * 0.6 / 2);
      x = (int) (r * cos(radians(360.0/numberOfDots*i + 3.333)));
      y = (int) (r * sin(radians(360.0/numberOfDots*i + 3.333)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[1]);
      }
      r = int(board.length * 0.55 / 2);
      x = (int) (r * cos(radians(360.0/numberOfDots*i + 6.666)));
      y = (int) (r * sin(radians(360.0/numberOfDots*i + 6.666)));
      if(abs(x) < board.length/2 && abs(y) < board[x+board.length/2].length/2) {
        board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[2]);
      }
    }
  }
  void clearOwners() {
    for (BoardElement[] b : board) {
      for (BoardElement c : b) {
        ((Cell)c).clearOwner();
      }
    }
  }

  public void drawBoard() {



    rectMode(CENTER);
    sendBorderUpdateUnclaimed(b[0]);
    sendBorderUpdateUnclaimed(b[1]);
    sendBorderUpdateUnclaimed(b[2]);
    sendBorderUpdateClaimed(b[0]);
    sendBorderUpdateClaimed(b[1]);
    sendBorderUpdateClaimed(b[2]);
    
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        setScore(b[0], x, y);
        setScore(b[1], x, y);
        setScore(b[2], x, y);
        int xPos = width / board.length * x + width / board.length / 2;
        int yPos =  height / board[x].length * y +  height / board[x].length / 2;
        int xSize = width / board.length + 1;
        int ySize =  height / board[x].length  + 1;

        if (((Cell)board[x][y]).hasOwner() && false) {
          board[x][y].setColor( board[x][y].getOwner().getColor());
        } else {

          board[x][y].setColor(color(255 - ((Cell)board[x][y]).getAllScores()[0], 
            255 - ((Cell)board[x][y]).getAllScores()[1], 
            255 - ((Cell)board[x][y]).getAllScores()[2]));
        }
        stroke(board[x][y].getColor());
        fill(board[x][y].getColor());
        rect(xPos, yPos, xSize, ySize);
      }
    }
    //for (Bot a : b) {
    //  sendBorderUpdateUnclaimed(a);
    //  sendBorderUpdateClaimed(a);
    //  setScore(a);
    //}
    
    //saveFrame("frames/####.png");
  }

  public void updateScores(Bot c) {
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
      }
    }
  }

  public void sendBorderUpdateUnclaimed(Bot c) {
    ArrayList<Cell> unclaimedBorder = new ArrayList<Cell>();

    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        if (board[x][y].getOwner() == null) {
          //                       x+      y+     x-    y-
          boolean[] directions = {
            (x < board.length - 1 && board[x+1][y].getOwner() != null && board[x+1][y].getOwner() == c), 
            (y < board[x].length - 1 && board[x][y+1].getOwner() != null && board[x][y+1].getOwner() == c), 
            (x > 0 && board[x-1][y].getOwner() != null && board[x-1][y].getOwner() == c), 
            (y > 0 && board[x][y-1].getOwner() != null && board[x][y-1].getOwner() == c)
          };
          if (directions[0] || directions[1] || directions[2] || directions[3]) {
            unclaimedBorder.add((Cell) board[x][y]);
            // Debug
            board[x][y].setColor(color(192, 192, 192));
          }
        }
      }
    }
    Cell[] bordersUC = unclaimedBorder.toArray(new Cell[0]);
    c.updateBordersUC(bordersUC);
  }

  public void sendBorderUpdateClaimed(Bot c) {
    ArrayList<Cell> claimedBorder = new ArrayList<Cell>();
    //println((board[1][1].getColor() + 256 * 256 * 256));

    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        if (board[x][y].getOwner() != null && board[x][y].getOwner() != c) {
          //                       x+      y+     x-    y-
          boolean[] directions = {
            (x < board.length - 1 && board[x+1][y].getOwner() != c && board[x][y].getOwner() == c), 
            (y < board[x].length - 1 && board[x][y+1].getOwner() != c && board[x][y].getOwner() == c), 
            (x > 0 && board[x-1][y].getOwner() != c && board[x][y].getOwner() == c), 
            (y > 0 && board[x][y-1].getOwner() != c && board[x][y].getOwner() == c)
          };
          if(directions[2]) println("AA");
          int b = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) % 256);
          int g = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) / 256 % 256);
          int r = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) / 256 / 256);
          
          //if (directions[0] || directions[1] || directions[2] || directions[3]) {
          if (board[x][y].getOwner() == c) {
            claimedBorder.add((Cell) board[x][y]);
            // debug
            //board[x][y].setColor(color(r, g, b));
          }
        }
      }
    }
    Cell[] bordersC = claimedBorder.toArray(new Cell[0]);
    c.updateBordersC(bordersC);
  }

  public void setScore(Bot bot, int x, int y) {

    //for (int x = 0; x < board.length; x++) {
    //  for (int y = 0; y < board[x].length; y++) {
        //if (board[x][y].getOwner() == null) {
        ((Cell)board[x][y]).calculateScore(bot);

        //}
    //  }
    //}
  }

  public int randInt(int min, int max) {
    return (min + (int) (Math.random() * (max - min)));
  }
}
