import java.util.Arrays;

public class Cell implements BoardElement {
  private color col;
  private PVector pos;
  private Bot owner;
  private int score;
  private Bot[] agents;
  private float[] scores;
  private float scale;
  
  Cell(color c, PVector p, Bot[] b) {
    col = c;
    pos = p;
    owner = null;
    score = 10000;
    agents = b;
    scores = new float[b.length];
    for (float s : scores) s = 0;
    scale = 1;
    //scale *=  (160-(sqrt((p.x - 125)*(p.x - 125) + (p.y - 125)*(p.y - 125))))/8;
    //scale *= ((cos(2*scale) +cos(3*scale) +cos(5*scale) +cos(7*scale) +cos(1*scale)) / 15 + 0.6); 
    scale *= 10-10*abs(cos(PI*p.x/10.0)*cos(PI*p.y/10.0));
    //scale *= 10*atan2(p.x, p.y);
  }
  
  public float gaussScale(float x) {
    float res = min(x, 100-x);
    return res;
  }
  
  public void clearOwner() {
    owner = null;
  }
  
  public void setScale(int s) {
    scale = s;
  }
  
  public float getScale() {
    return scale;
  }
  
  public float[] getScores(Bot b) {
    float[] list = new float[scores.length - 1];
    
    int i = 0;
    for (float s : scores) {
      if (agents[i] != b) {
        list[i] = s;
        i++;
      }
    }
    
    return list;
  }
  
  public void calculateScore(Bot b) {
    float tScores = 1000;
    for (int i = 0; i < agents.length; i++) {
      int botRed = (int) red(agents[i].getColor())==255?1:0;
      int botGreen = (int) green(agents[i].getColor())==255?1:0;
      int botBlue = (int) blue(agents[i].getColor())==255?1:0;
      if (agents[i].getBorderCellsUC() == null) {
        setScore(b, 0);
        return;
      }
      for (Cell cell : agents[i].getBorderCellsUC()) {
        if (b != agents[i]) continue;
        int dx = (int) abs(cell.getPosition().x - pos.x);
        int dy = (int) abs(cell.getPosition().y - pos.y);
        
        float distance = sqrt(dx*dx + dy*dy) * scale;
        tScores = min(distance, tScores);
      }
      
    }
    setScore(b, tScores);
  }
  
  public float getScore(Bot bot) {
    int i = 0;
    for (Bot b : agents) {
      if (bot == b) {
        return scores[i];
      }
      i++;
    }
    return 0;
  }
  
  public void setScore(Bot bot, float s) {
    int i = 0;
    for (Bot b : agents) {
      if (bot == b) {
        scores[i] = s;
        return;
      }
      i++;
    }
  }
  
  public float[] getAllScores() {
    return scores;
  }
  
  public void setColor(color c) {
    col = c;
  }
  public void setOwner(Bot o) {
    owner = o;
    col = o.getColor();
  }
  
  public color getColor() {
    return col;
  }
  public PVector getPosition() {
   return pos; 
  }
  
  public Bot getOwner() {
   return owner; 
  }
  
  public boolean claimed() {
    return owner != null;
  }
  
  public boolean isOwner() {
    if (owner == null) return false;
   return owner.getPosition() == pos; 
  }
  
  public boolean hasOwner() {
    return owner != null;
  }
  
  public boolean isBorder() {
    if (getOwner() == null) {
      return false;
    }
    return Arrays.asList(getOwner().getBorderCellsUC()).contains(this) || Arrays.asList(getOwner().getBorderCellsC()).contains(this);
  }
}
