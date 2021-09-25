public interface BoardElement {
  
  color getColor();
  PVector getPosition();
  Bot getOwner();
  boolean isOwner();
  boolean isBorder();
  float getScore(Bot bot);
  void setOwner(Bot c);
  void setColor(color c);
  
}
