public class Bot implements BoardElement {
  private color col;
  private PVector pos;
  private Cell[] borderCellsUC;
  private Cell[] borderCellsC;
  private Cell[] ownedCells;
  Bot(color c, PVector p) {
    col = c;
    pos = p;
    // borderCellsC = new Cell[1];
    
  }
  
  public void setColor(color c) {
    col = c;
  }
  
  public Cell[] getBorderCellsC() {
   return borderCellsC; 
  }
  
  public Cell[] getBorderCellsUC() {
   return borderCellsUC; 
  }
  
  public Cell[] getOwnedCells() {
   return ownedCells; 
  }
  
  
  public void conquerClaimedCell(Cell c) {
    Cell[] newC = new Cell[ownedCells.length + 1];
    for (int i = 0; i < ownedCells.length; i++) {
      newC[i] = ownedCells[i];
    }
    newC[ownedCells.length] = c;
    ownedCells = newC;
  }
  
  public void conquerUnclaimedCell(Cell c1, Cell c2) {
    Cell[] newC = new Cell[ownedCells.length + 2];
    for (int i = 0; i < ownedCells.length; i++) {
      newC[i] = ownedCells[i];
    }
    newC[ownedCells.length] = c1;
    newC[ownedCells.length + 1] = c2;
    ownedCells = newC;
  }
  
  public void updateBordersUC(Cell[] bc) {
    borderCellsUC = bc;
  }
  
  public void updateBordersC(Cell[] bc) {
    borderCellsC = bc;
  }
  
  public void setOwner(Bot o) {
  }
  
  public color getColor() {
    return col;
  }
  public PVector getPosition() {
   return pos; 
  }
  
  public Bot getOwner() {
   return this; 
  }
  
  public boolean isOwner() {
   return true; 
  }
  
  public boolean isBorder() {
    return false;
  }
  public float getScore(Bot bot) {
    int cellScore = 0;
    return cellScore;
  }
  
}
