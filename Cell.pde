import java.util.Arrays;

public class Cell implements BoardElement {
  private color col;
  private PVector pos;
  private Bot owner;
  private int score;
  private Bot[] agents;
  private float[] scores;
  private float scale;
  private int bsx;
  private int bsy;

  Cell(color c, PVector p, Bot[] b, int boardSizeX, int boardSizeY) {
    bsx = boardSizeX;
    bsy = boardSizeY;
    col = c;
    pos = p;
    owner = null;
    score = 10000;
    agents = b;
    scores = new float[b.length];
    for (float s : scores) s = 0;
  
    // These are your main parameters for this whole thing
    float cosScale = 75;
    scale = 200;
    float dotGridScale = 5;
    PVector centeroffset = new PVector(bsx/2, bsy/2, 0);
    float dotAmt = 40;
    float dotFallOffStrength = 10;
    float hyperbolicScale = 1;


    // DONT ALTER THIS (FOR NOW)
    PVector offsetPos = new PVector(p.x - centeroffset.x, p.y - centeroffset.y);
    dotAmt = bsx/dotAmt;
    cosScale = 1.0/bsx*cosScale;
    float distFromOff = sqrt((p.x - centeroffset.x)*(p.x - centeroffset.x) + (p.y - centeroffset.y)*(p.y - centeroffset.y));
    scale = 1.0/bsx*(100*scale);
    // END OF DO NOT ALTER
    
    // these 6 methods can be combined in any way you want.
    // scale = hyperbolicLike(scale, distFromOff, hyperbolicScale);
    //scale = primeCosineRings(scale, distFromOff, cosScale, 15, 0.6);
    //scale = dotMatrix(scale, offsetPos, dotAmt, dotFallOffStrength);
    //scale = grid(scale, p, dotAmt, dotFallOffStrength);
    // scale = atanMap(scale, p.y, p.x, 1);
    //scale = dotGrid(dotGridScale, p.x, p.y, 100, 0.2, 150);
    //scale = betterDots(2, p.x, p.y, 10, 0.4, 4, 8, 8, 10);
    //scale = betterDots(2, cartesianToPolar(p).x, cartesianToPolar(p).y, 10, 0.4, 4, 10, 8, 10);
    float tScale = scale;
    float stepCount = 6;
    float substepCount = 8;
    
    //float s1 = betterDots(scale, cartesianToPolar(p).x,                                 cartesianToPolar(p).y,                                 stepCount, 0.4, 4, substepCount, 8, 10);
    //float s2 = betterDots(scale, cartesianToPolar(new PVector(p.x - bsx, p.y)).x,       cartesianToPolar(new PVector(p.x - bsx, p.y)).y,       stepCount, 0.4, 4, substepCount, 8, 10);
    //float s3 = betterDots(scale, cartesianToPolar(new PVector(p.x, p.y - bsy)).x,       cartesianToPolar(new PVector(p.x, p.y - bsy)).y,       stepCount, 0.4, 4, substepCount, 8, 10);
    //float s4 = betterDots(scale, cartesianToPolar(new PVector(p.x - bsx, p.y - bsy)).x, cartesianToPolar(new PVector(p.x - bsx, p.y - bsy)).y, stepCount, 0.4, 4, substepCount, 8, 10);
    //scale = min(s1, s2, s3);
    //scale = min(scale, s4, dotMatrix(scale, offsetPos, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength));
    
    //caleidoscopic
    //scale = caleidoscope(4.5, p, 0.01, 0.5, 1);
    //scale =  min(scale, dotMatrix(scale, offsetPos, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength));
    
    // s0
    //scale = dotMatrix(scale, p, distFromOff, dotFallOffStrength);
    
    // cardioid
    //scale = dotMatrix(scale, cartesianToPolar(offsetPos), distFromOff, dotFallOffStrength);
    
    
    
    scale =altCosLines(6, p, 0.1, 0.5, 0.25, 1, 2);
    //fun thing:
    scale = primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), atanMap(scale, p.y, p.x, 1), dotMatrix(scale, p, dotAmt, dotFallOffStrength), 15, 0.6);
    //scale = minSquares(scale, p.x, p.y, 10, 0);
    //omin mind:
   //scale = dotMatrix(primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), distFromOff, cosScale, 15, 0.6), p, hyperbolicLike(primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), distFromOff, cosScale, 15, 0.6), distFromOff, hyperbolicScale), dotFallOffStrength);
   
   //scale = betterDots(2, p.x, p.y, hyperbolicLike(scale, distFromOff, hyperbolicScale), 0.4, 4, 8, 8, 10);
    
    // cover warped fots
    //scale = dotMatrix(scale, p, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength);
  }


  // Sort of hyperbolic but not really. DistFromOff is the distance a cell has from the specified center (PVector centeroffset), space is "compressed" according to how close
  // The cell is, meaning cells further away from the center are closer to EVERY cell at once.
  private float hyperbolicLike(float in, float distFromOff, float divisor) {
    return in * (sqrt(bsx*bsx/divisor + bsy*bsy/divisor)-(distFromOff))/(2*sqrt(bsx*bsx/divisor + bsy*bsy/divisor)/10);
  }
  
  private float linearCosStripes(float scale, PVector p, float angle, float f, float thresh, float epsilon, float off) {
    angle = radians(angle);
    float slopeY = cos(angle);
    float slopeX = sin(angle);
    return abs(cos(f * (slopeX * p.x + slopeY * p.y)) - thresh) <= epsilon ? off : scale; 
  }
  
  private float cosLines(float sc, PVector pos, float frequency, float thresh, float epsilon, float off, boolean multiply) {
    float s1 = cos(cartesianToPolar(pos).y * frequency);
    float s2 = cos(cartesianToPolar(new PVector(pos.x - bsx, pos.y)).y * frequency);
    float s3 = cos(cartesianToPolar(new PVector(pos.x - bsx, pos.y - bsy)).y * frequency);
    float s4 = cos(cartesianToPolar(new PVector(pos.x , pos.y - bsy)).y * frequency);
    
    float isLine1 = abs(s1-thresh)<=epsilon?0:1;
    float isLine2 = abs(s2-thresh)<=epsilon?0:1;
    float isLine3 = abs(s3-thresh)<=epsilon?0:1;
    float isLine4 = abs(s4-thresh)<=epsilon?0:1;
    if (multiply) {
      return (sc - off) * (isLine1 * isLine2 * isLine3 * isLine4) / 4 + off;
    } 
    return (sc - off) * (isLine1 + isLine2 + isLine3 + isLine4) / 4 + off;
  }
  
  private float altCosLines(float sc, PVector pos, float frequency, float thresh, float epsilon, float off, int mode) {
    float s1 = cos(cartesianToPolar(pos).y * frequency);
    float s2 = cos(cartesianToPolar(new PVector(pos.x - bsx, pos.y)).y * frequency);
    float s3 = cos(cartesianToPolar(new PVector(pos.x - bsx, pos.y - bsy)).y * frequency);
    float s4 = cos(cartesianToPolar(new PVector(pos.x , pos.y - bsy)).y * frequency);
    
    float weight = 0;
    
    switch (mode) {
      case 0:
        weight = sqrt(sqrt(s1 * s2 * s3 * s4));
        break;
      case 1:
        weight = (s1 + s2 + s3 + s4)/4;
        break;
      case 2: 
        weight = max(s1, s2, s3);
        weight = max(weight, s4);
        break;
      case 3: 
        weight = min(s1, s2, s3);
        weight = min(weight, s4);
        break;
      default:
        weight = (s1 * (s2+s3+s4)/3 + s2 * (s1+s3+s4)/3 + s3 * (s2+s1+s4)/3 + s4 * (s2+s3+s1)/3)/4;
    }
    
    
    
    
    
    float isLine = abs(weight-thresh)<=epsilon?0:1;
    
    
    return (sc - off) * isLine / 4 + off;
  }
  
  
  private float caleidoscope(float sc, PVector p, float frequency, float pointy, float sharp) {
    float cscale = 0;
    float s1 = sc * pow(cos((cartesianToPolar(p).y * frequency) + pointy)                                , sharp);
    float s2 = sc * pow(cos((cartesianToPolar(new PVector(p.x - bsx, p.y)).y * frequency) + pointy)      , sharp);
    float s3 = sc * pow(cos((cartesianToPolar(new PVector(p.x - bsx, p.y - bsy)).y * frequency) + pointy), sharp);
    float s4 = sc * pow(cos((cartesianToPolar(new PVector(p.x , p.y - bsy)).y * frequency) + pointy)     , sharp);
    cscale = max(s1, s2, s3);
    cscale = max(cscale, s4);
    return cscale;
  }
  
  private float primeCosineRings(float in, float distFromOff, float cosScale, float divisor, float offset) {
    return in * (((cos(2*distFromOff*cosScale) +cos(3*distFromOff*cosScale) +cos(5*distFromOff*cosScale) +cos(7*distFromOff*cosScale) +cos(1*distFromOff*cosScale)) / divisor + offset));
  }

  private float dotMatrix(float in, PVector p, float dotAmt, float dotFallOffStrength) {
    return in * (dotFallOffStrength-dotFallOffStrength*abs(cos(PI*p.x/dotAmt)*cos(PI*p.y/dotAmt)));
  }

  private float grid(float in, PVector p, float dotAmt, float dotFallOffStrength) {
    return -in * (-dotFallOffStrength-dotFallOffStrength*abs(cos(PI*p.x/dotAmt)*cos(PI*p.y/dotAmt)));
  }

  private float atanMap(float in, float x, float y, float falloff) {
    return falloff*atan2(x, y);
  }

  private float dotGrid(float in, float x, float y, float a, float b, float f) {
    float sx = abs(cos(f * x));
    float sy = abs(cos(f * y));
    
    float px = pow(sx, a);
    float py = pow(sy, a);
    
    float exponent = (b - 1 / a);
    float fx = (1 - px);
    float fy = (1 - py);
    return in * (pow(fx, exponent) + pow(fy, exponent));
  }
  
  private float crossripples(float in, float x, float y, float a, float b, float f) {
    float sx = abs(cos(f * x));
    float sy = abs(cos(f * y));
    
    float px = pow(sx, a);
    float py = pow(sy, a);
    
    float exponent = (b - 1 / a);
    float fx = (1 - px);
    float fy = (1 - py);
    return in * (pow(fx, exponent) * pow(fy, exponent));
  }
  
  private float triangleWave(float in, float x, float y, float freq) {
    return in * abs((freq*x)%2 - 1) * abs((freq*y)%2 - 1);
  }
  
  private float legacyDots(float scale, float x, float y, 
                           float steps, float stepSharpness, float stepFalloff,
                           float subSteps, float subSharpness, float subFalloff) {
     float stepExponent = (stepFalloff - (1 / stepSharpness));
     float qx = pow(1 - (1 - abs(sin(steps * PI * x))), stepExponent);
     float qy = pow(1 - (1 - abs(sin(steps * PI * y))), stepExponent);
     
     
     subSteps = steps * subSteps;
     float subExponent = (subFalloff - (1 / subSharpness));
     float rx = pow(1 - (1 - abs(sin(subSteps * PI * x))), subExponent);
     float ry = pow(1 - (1 - abs(sin(subSteps * PI * y))), subExponent);
     
     float vx = (1 - qx) + qx*rx;
     float vy = (1 - qy) + qy*ry;
     
     return scale * (vx + vy);
   }
   
   private float minSquares(float in, float x, float y, float offX, float offY) {
     float smallestXDiff = bsx;
     float smallestYDiff = bsy;
     for (Bot a : agents) {
        for (Cell c : a.getOwnedCells()) {
          
        }
      }
      return 0;
   }
   
   private PVector cartesianToPolar(PVector in) {
     PVector out = new PVector(0,0);
     
     out.x = atan(in.y / in.x);
     out.y = sqrt(in.x*in.x + in.y*in.y);
     
     return out;
   }
   
   private float betterDots(float scale, float x, float y, 
                           float steps, float stepSharpness, float stepFalloff,
                           float subSteps, float subSharpness, float subFalloff) {
     subSteps += 1;
     steps = 1 / (bsx / steps);
     float stepExponent = (stepFalloff - (1 / stepSharpness));
     float qx = pow(1 - pow(1 - abs(sin(steps * PI * x)), stepSharpness), stepExponent);
     float qy = pow(1 - pow(1 - abs(sin(steps * PI * y)), stepSharpness), stepExponent);
     
     
     subSteps = steps * subSteps;
     float subExponent = (subFalloff - (1 / subSharpness));
     float rx = pow(1 - pow(1 - abs(sin(subSteps * PI * x)), subSharpness), subExponent);
     float ry = pow(1 - pow(1 - abs(sin(subSteps * PI * y)), subSharpness), subExponent);
     
     float vx = (1 - qx) + qx*rx;
     float vy = (1 - qy) + qy*ry;
     
     return scale * (vx + vy);
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
