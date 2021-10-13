import java.util.Arrays;
import java.lang.Math;
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
    scale = 10;
    float dotGridScale = 1;
    PVector centeroffset = new PVector(bsx, bsy, 0);
    float dotAmt = 40;
    float dotFallOffStrength = 3;
    float hyperbolicScale = 1;
    float tScale = scale;
    float stepCount = 6;
    float substepCount = 8;

    // DONT ALTER THIS (FOR NOW)
    PVector offsetPos = new PVector(p.x - centeroffset.x, p.y - centeroffset.y);
    dotAmt = bsx/dotAmt;
    cosScale = 1.0/bsx*cosScale;
    float distFromOff = sqrt((p.x - centeroffset.x)*(p.x - centeroffset.x) + (p.y - centeroffset.y)*(p.y - centeroffset.y));
    scale = 1.0/bsx*(100*scale);
    // END OF DO NOT ALTER
    
    PVector hbpos = cartesianToHyperbolic(scale(offsetPos, 0.001));
    float hyperDist = sqrt(hbpos.x*hbpos.x + hbpos.y*hbpos.y);
    //if(hbpos.y % 10 > 9 || hbpos.x % 10 > 9.9 || hbpos.x % 10 < .1) {
    //  scale = 0;
    //} else {
    //  scale = 100;
    //}
    //scale = hyperDist;
    
   // scale = distFromOff / 10 / hyperDist;
   
    // these  methods can be combined in any way you want.
    //scale = hyperbolicLike(scale, distFromOff, hyperbolicScale);
    scale = primeCosineRings(scale, distFromOff, cosScale, 15, 0.6);
    //scale = rays1(scale, offsetPos, hyperDist, dotFallOffStrength, 73, 325, 184);
    
    
    ///////////////////////////
    //float fac = 130;
    //float offset = 2;
    //float freq = hbpos.x * hbpos.y / 100 * 36;
    
    
    // float f1 = -cos(radians((cartesianToPolar(offsetPos).x        ) * freq)) + 1;
    // float f2 = -cos(radians((cartesianToPolar(offsetPos).x + 360.0/freq/3) * freq)) + 1;
    // float f3 = -cos(radians((cartesianToPolar(offsetPos).x + 360.0/freq/3*2) * freq)) + 1;
     
    // scale = fac * min(f1, f2, f3) + offset;
     ///////////////////////////////
     //float m1 = ( (0.004 * (((cartesianToPolar(offsetPos).x + 180) * (0.885) + distFromOff)) * PI) + 1 )% 4;
     //float m2 = ( (0.03 * (((-cartesianToPolar(offsetPos).x + 180) * (0.885) + distFromOff)) * PI) + 1 )% 10;
     //scale = m1 + m2;
    // radius: 325
    //scale = 3;
    //scale = grid(scale, p, dotAmt, dotFallOffStrength);
    //scale = atanMap(scale, p.y, p.x, 1);
    //scale = dotGrid(dotGridScale, offsetPos.x, offsetPos.y, 100, 0.2, 150);
    
    /*
    betterDots(scale, x, y, steps, stepSharpness, stepFalloff, subSteps, subSharpness, subFalloff)
     */
     
    //scale = betterDots(1, offsetPos.x, offsetPos.y, 10, 0.4, 4, 8, 8, 10);
    //scale = betterDots(scale, cartesianToPolar(offsetPos).x, cartesianToPolar(offsetPos).y, 10, 0.4, 4, 10, 8, 10);
    
    
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
    //scale = dotMatrix(scale, hbpos, distFromOff, dotFallOffStrength);
    
    //s0 with more weirdness
    //scale = dotMatrix(scale, p, distFromOff, dotFallOffStrength);
    //scale = dotMatrix(scale, p, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength);
    
    // cardioid
    //scale = dotMatrix(scale, cartesianToPolar(offsetPos), distFromOff, dotFallOffStrength);
    
    //flower thing
    //scale = flower(1, offsetPos, 12, 10, bsx * 0.2, 0.6, 0);
    //scale = flower2(1, offsetPos, 12, 10, bsx * 0.2, 0.6, 0,false);
    
    
    //scale =altCosLines(6, p, 0.1, 0.5, 0.25, 1, 2);
    //fun thing:
    //scale = primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), atanMap(scale, p.y, p.x, 1), dotMatrix(scale, p, dotAmt, dotFallOffStrength), 15, 0.6);
    //scale = minSquares(scale, p.x, p.y, 10, 0);
    //omin mind:
   //scale = dotMatrix(primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), distFromOff, cosScale, 15, 0.6), p, hyperbolicLike(primeCosineRings(hyperbolicLike(scale, distFromOff, hyperbolicScale), distFromOff, cosScale, 15, 0.6), distFromOff, hyperbolicScale), dotFallOffStrength);
   
   //scale = betterDots(2, p.x, p.y, hyperbolicLike(scale, distFromOff, hyperbolicScale), 0.4, 4, 8, 8, 10);
    
    //overlapping circles
    //scale = circles(2, p, 1, 1, 1);
    
    
    
    // cover warped fots
    //scale = dotMatrix(scale, p, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength);
  }

//Predefined scale
Cell(color c, PVector p, Bot[] b, int boardSizeX, int boardSizeY, float scl) {
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
    scale = 10;
    float dotGridScale = 1;
    PVector centeroffset = new PVector(bsx/2, bsy/2, 0);
    float dotAmt = 40;
    float dotFallOffStrength = 10;
    float hyperbolicScale = 1;
    float tScale = scale;
    float stepCount = 6;
    float substepCount = 8;

    // DONT ALTER THIS (FOR NOW)
    PVector offsetPos = new PVector(p.x - centeroffset.x, p.y - centeroffset.y);
    dotAmt = bsx/dotAmt;
    cosScale = 1.0/bsx*cosScale;
    float distFromOff = sqrt((p.x - centeroffset.x)*(p.x - centeroffset.x) + (p.y - centeroffset.y)*(p.y - centeroffset.y));
    scale = 1.0/bsx*(100*scale);
    // END OF DO NOT ALTER
    
    PVector imgV = scale(offsetPos, scl);
    float phase = 5;
    float d = distance(scale(imgV, 0.05));
    if (((int) (d + phase) / 5) % 2 == 0) {
      scale = (d + phase) % 5;
    } else {
      scale = 5 - (d + phase) % 5;
    }
    
    
    
    //scale = scl;
    //scale = dotMatrix(scale, p, dotAmt * hyperbolicLike(scale, distFromOff, hyperbolicScale), dotFallOffStrength);
}

private float rays1(float scale, PVector offsetPos, float hyperDist, float dotFallOffStrength, float a, float b, float c) {
      float gaussa = 73;
      float gaussb = 325;
      float gaussc = 184;
      float distFromOff = distance(offsetPos);
      float f1 = gaussc / (gaussa * sqrt(TWO_PI));
      float f2 = -0.5 * pow((distFromOff - gaussb) / gaussa, 2);
      float newscale = f1 * exp(f2);
      
      return dotMatrix(10, offsetPos, hyperDist, dotFallOffStrength) + 1/newscale;
    }

  // Sort of hyperbolic but not really. DistFromOff is the distance a cell has from the specified center (PVector centeroffset), space is "compressed" according to how close
  // The cell is, meaning cells further away from the center are closer to EVERY cell at once.
  private float hyperbolicLike(float in, float distFromOff, float divisor) {
    return in * (sqrt(bsx*bsx/divisor + bsy*bsy/divisor)-(distFromOff)) / (2*sqrt(bsx*bsx/divisor + bsy*bsy/divisor)/10);
  }
  
  private PVector scale(PVector in, float s) {
    return new PVector(in.x * s, in.y * s);
  }
  
  private PVector translate(PVector v, PVector t) {
    return new PVector(v.x + t.x, v.y + t.y);
  }
  
  private PVector translate(PVector v, float x, float y) {
    return new PVector(v.x + x, v.y + y);
  }
  
  private float distance(PVector v) {
    return sqrt(v.x*v.x + v.y*v.y);
  }
  
  private float circles (float scaling, PVector p, float pow, float fac, float offset) {
    //float scaling = 100 / sqrt(bsx/2*bsx/2 + bsy/2*bsy/2);
    //float pow = 1;
    //float fac = 1;
    //float offset = 1;
    
    PVector c1 = new PVector(0,0);
    PVector c2 = new PVector(bsx,0);
    PVector c3 = new PVector(0,bsy);
    PVector c4 = new PVector(bsx,bsy);
    
    float dist1 = scaling * sqrt( (c1.x - p.x)*(c1.x - p.x) + (c1.y - p.y)*(c1.y - p.y) );
    float dist2 = scaling * sqrt( (c2.x - p.x)*(c2.x - p.x) + (c2.y - p.y)*(c2.y - p.y) );
    float dist3 = scaling * sqrt( (c3.x - p.x)*(c3.x - p.x) + (c3.y - p.y)*(c3.y - p.y) );
    float dist4 = scaling * sqrt( (c4.x - p.x)*(c4.x - p.x) + (c4.y - p.y)*(c4.y - p.y) );
    
    float m1 = fac - (fac * pow(abs((dist1 % 2) - 1), pow));
    float m2 = fac - (fac * pow(abs((dist2 % 2) - 1), pow));
    float m3 = fac - (fac * pow(abs((dist3 % 2) - 1), pow));
    float m4 = fac - (fac * pow(abs((dist4 % 2) - 1), pow));
    
    return (min(min(m1,m2,m3), m4 ) + offset);
  }
  
  private float flower2(float in, PVector pos, float numberOfDots, float mod, float r, float pwr, float phase, boolean cosineFilter) {
    
    PVector[] cc = new PVector[floor(numberOfDots)];
    float[] d = new float[floor(numberOfDots)];
    
    for (float i = 0; i < floor(numberOfDots); i++) {
      float x = (r * cos(radians(360.0/numberOfDots*i)));
      float y = (r * sin(radians(360/numberOfDots*i)));
      cc[floor(i)] = new PVector(x,y);
      d[floor(i)] = abs(dist(cc[(int) i].x, cc[(int) i].y, pos.x,pos.y));
    }
    
    float temp = 1;
    
    for(int i = 0; i < floor(numberOfDots); i++) {
      temp += d[i];
    }
    
    float fac;
    float mind = min(d) * (cosineFilter?(cos(min(d)/ 10) + 1):1);
    if (int(mind / mod) % 2 == 0) {
      fac = mind % mod;
    } else {
      fac = mod - (mind % mod);
    }
    
    return in * pow(fac, pwr);
  }
  
  private float flower(float in, PVector pos, float numberOfDots, float mod, float r, float pwr, float phase){
    
    PVector[] cc = new PVector[floor(numberOfDots)];
    float[] d = new float[floor(numberOfDots)];
    
    for (float i = 0; i < floor(numberOfDots); i++) {
      float x = (r * cos(radians(360.0/numberOfDots*i)));
      float y = (r * sin(radians(360/numberOfDots*i)));
      cc[floor(i)] = new PVector(x,y);
      d[floor(i)] = abs(dist(cc[(int) i].x, cc[(int) i].y, pos.x,pos.y));
    }
    
    float temp = 1;
    
    for(int i = 0; i < floor(numberOfDots); i++) {
      temp *= d[i];
    }
    
    
    float fac;
    if (int(   (pow(temp, 1.0/(numberOfDots + 1)) + phase) / mod)    % 2 == 0) {
      fac =    (pow(temp, 1.0/(numberOfDots + 1)) + phase) % mod;
    } else {
      fac = mod - (pow(temp, 1.0/(numberOfDots + 1)) + phase) % mod;
    }
    return in * pow(fac, pwr); 
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
  
  //OSLed
  private float primeCosineRings(float in, float distFromOff, float cosScale, float divisor, float offset) {
    return in * (
    (
      (
      cos(2*distFromOff*cosScale)
      +cos(3*distFromOff*cosScale) 
      +cos(5*distFromOff*cosScale) 
      +cos(7*distFromOff*cosScale) 
      +cos(1*distFromOff*cosScale)) / divisor + offset));
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
   
   //OSLed
   private PVector cartesianToPolar(PVector in) {
     PVector out = new PVector(0,0);
     
     out.x = degrees(atan2(in.y , in.x));
     out.y = sqrt(in.x*in.x + in.y*in.y);
     
     return out;
   }
   
   //OSLed
   private PVector cartesianToHyperbolicLike(PVector in) {
     PVector out = new PVector(0,0);
     in = cartesianToPolar(in);
     
     //if (in.x < 90 || (in.x > 270 && in.x< 360)) {
     //  in.x += 90;
     //}
     
     out.y = (in.y) * abs((float) Math.cosh(radians(in.x)));
     out.x = (in.y) * abs((float) Math.sinh(radians(in.x)));
     
     return out;
   }
   
   //
   private PVector cartesianToHyperbolicOld(PVector in) {
     PVector out = new PVector(0,0);
     PVector s = in;
     if(in.y == 0) in.y = 0.0001;
     if(in.x == 0) in.x = 0.0001; 
     
     
     if (in.x > 0 && in.y <= 0) in.y *= -1;
     if (in.x < 0 && in.y >= 0) in.y *= -1;
     
     out.x = log(sqrt(in.x/in.y));
     out.y = sqrt(in.x*in.y);
     
     float r = out.y;
     float t = out.x;
     
     out.y = (r) * ((float) Math.cos(radians(t)));
     out.x = (r) * abs((float) Math.sin(radians(t)));
     out.x = cartesianToPolar(s).x + 180;
     
     
     return out;
   }
   
   private PVector cartesianToParabolic(PVector in) {
     PVector out = new PVector(0,0);
     PVector s = in;
     if(in.y == 0) in.y = 0.0001;
     if(in.x == 0) in.x = 0.0001; 
     
     
     if (in.x > 0 && in.y <= 0) in.y *= -1;
     if (in.x < 0 && in.y >= 0) in.y *= -1;
     
     out.x = sqrt( (sqrt(in.x*in.x + in.y*in.y) + in.x ) / 2 );
     out.y = sqrt( (sqrt(in.x*in.x + in.y*in.y) - in.x ) / 2 );
     
     
     return out;
   }
   
   // OSLed
   private PVector cartesianToHyperbolic(PVector in) {
     PVector out = new PVector(0,0);
     PVector s = in;
     if(in.y == 0) in.y = 0.0001;
     if(in.x == 0) in.x = 0.0001; 
     
     
     if (in.x > 0 && in.y <= 0) in.y *= -1;
     if (in.x < 0 && in.y >= 0) in.y *= -1;
     
     out.y = sqrt( sign(in.x + in.y) * sign(in.y - in.x) * (in.y*in.y - in.x*in.x) / 2 );
     out.x = sqrt( sign(in.x) * sign(in.y) * in.x * in.y);
     
     
     return out;
   }
   //
   private PVector euclidToExponential(PVector in) {
     PVector out = new PVector(0,0);
     
     in = cartesianToPolar(in);
     
     in.y = exp(in.y/100);
     
     out.y = (in.y) * abs((float) Math.cos(radians(in.x)));
     out.x = (in.y) * abs((float) Math.sin(radians(in.x)));
     
     return out;
   }
   
   private int sign(float f) {
      if (f > 0) return 1;
      if (f < 0) return -1;
      return 0;
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
      
      for (Cell cell : agents[i].getOwnedCells()) {
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
    o.conquerClaimedCell(this);
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
