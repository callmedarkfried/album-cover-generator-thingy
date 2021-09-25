import java.util.ArrayList; //<>//
public class Board {
  private BoardElement[][] board;
  private int currentScale = 10;

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
    if (testPattern) frame();
  }

  public int[] getSize() {
    int[] s = {board.length, board[0].length};
    return s;
  }

  public void addTile(int x, int y, int i) {
    board[x][y].setOwner(b[i]);
  }
  public void frame() {
    clearOwners();
   for (float i = 0; i < 38; i++) {
      int r = int(board.length * 0.65 / 2);
      int x = (int) (r * cos(i/TWO_PI));
      int y = (int) (r * sin(i/TWO_PI));
      board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[0]);
      
      r = int(board.length * 0.6 / 2);
      x = (int) (r * cos(i+0.5/TWO_PI));
      y = (int) (r * sin(i+0.5/TWO_PI));
      board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[1]);
      
      r = int(board.length * 0.55 / 2);
      x = (int) (r * cos(i+1/TWO_PI));
      y = (int) (r * sin(i+1/TWO_PI));
      board[x+board.length/2][y+board[x+board.length/2].length/2].setOwner(b[2]);
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
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
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
    sendBorderUpdateUnclaimed(b[0]);
    sendBorderUpdateUnclaimed(b[1]);
    sendBorderUpdateUnclaimed(b[2]);
    sendBorderUpdateClaimed(b[0]);
    sendBorderUpdateClaimed(b[1]);
    sendBorderUpdateClaimed(b[2]);
    setScore(b[0]);
    setScore(b[1]);
    setScore(b[2]);
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
            (x < board.length - 1 && board[x+1][y].getOwner() != null && board[x+1][y].getOwner() == c), 
            (y < board[x].length - 1 && board[x][y+1].getOwner() != null && board[x][y+1].getOwner() == c), 
            (x > 0 && board[x-1][y].getOwner() != null && board[x-1][y].getOwner() == c), 
            (y > 0 && board[x][y-1].getOwner() != null && board[x][y-1].getOwner() == c)
          };
          int b = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) % 256);
          int g = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) / 256 % 256);
          int r = 255 - ((board[x][y].getOwner().getColor() + 256 * 256 * 256) / 256 / 256);
          if (directions[0] || directions[1] || directions[2] || directions[3]) {
            claimedBorder.add((Cell) board[x][y]);
            // debug
            board[x][y].setColor(color(r, g, b));
          }
        }
      }
    }
    Cell[] bordersC = claimedBorder.toArray(new Cell[0]);
    c.updateBordersC(bordersC);
  }

  public void setScore(Bot bot) {

    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        //if (board[x][y].getOwner() == null) {
        ((Cell)board[x][y]).calculateScore(bot);

        //}
      }
    }
  }

  public int randInt(int min, int max) {
    return (min + (int) (Math.random() * (max - min)));
  }
}
