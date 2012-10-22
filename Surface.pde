public class Surface {
  PImage img;
  boolean pixelsLoaded = false;

  int pattern;
  PVector patternCenter;
  int patternStep = 0;
  int patternPeriod = 60;
  float patternScale = 1;
  static final int GRADIENT_LEFT_RIGHT = 0;
  static final int GRADIENT_TOP_BOTTOM = 1;
  static final int GRADIENT_CORNER = 2;
  static final int GRADIENT_RADIAL = 3;
  static final int RIPPLE = 4;
  static final int WHITE_NOISE = 5;
  static final int PERLIN_NOISE = 6;
  
  int downSample = 8;
  
  public Surface(int w, int h) {
    img = createImage(w/downSample, h/downSample, ALPHA);
    patternCenter = new PVector(w/2, h/2);
    pattern = RIPPLE;
  }
  
  public void update() {
    patternStep++;
    if(patternStep > patternPeriod / (pattern == WHITE_NOISE ? 2 : 1)) patternStep = 0;
    img.loadPixels();
    float val = 0;
    for(int x=0; x<img.width; x++) {
      for(int y=0; y<img.height; y++) {
        switch(pattern) {
          case GRADIENT_LEFT_RIGHT:
            val = abs(0.5 - abs(((x / patternScale)/(float)img.width - patternStep/(float)patternPeriod) % 1));
            break;
          case GRADIENT_TOP_BOTTOM:
            val = abs(0.5 - abs(((y / patternScale)/(float)img.height - patternStep/(float)patternPeriod) % 1));
            break;        
          case GRADIENT_CORNER:
            val = abs(0.5 - abs((((y+x) / patternScale)/(float)img.height - patternStep/(float)patternPeriod) % 1));
            break;               
          case RIPPLE:
            float dist = sqrt(sq(patternCenter.x - x) + sq(patternCenter.y - y)) / patternScale / (20./downSample);
            val = cos(dist - (TWO_PI*patternStep/(float)patternPeriod)) / 2. + 0.5;
            val *= 5/dist*constrain(patternScale,0,1);
            val = constrain(val, 0,1);
            break;
          case WHITE_NOISE:
            val = patternStep == 0 ? random(0,1) : (img.pixels[y*img.width + x] / 255.);
            break;
          case PERLIN_NOISE:
            val = noise(x/(float)img.width*5 * patternScale, y/(float)img.height*5 * patternScale, frameCount/(float)patternPeriod*10./downSample);
            val = constrain(val*val * 2, 0,1);
          default:
            break;
        }
        img.pixels[y*img.width + x] = (int)(val * 255);   
      }
    }
    img.updatePixels();
    pixelsLoaded = false;
  }
  
  public void draw() {
    this.draw(0,0,img.width*downSample, img.height*downSample);  
  }
  
  public void draw(int Px, int Py, int w, int h) {
    tint(255);
    image(img, Px, Py, w, h);
  }
  
  public int sampleAt(int x, int y) {
    x /= downSample;
    y /= downSample;
    if(!pixelsLoaded) {
      img.loadPixels();
      pixelsLoaded = true;
    }
    
    try {
      return img.pixels[img.width*(y-1) + x];
    }
    catch(ArrayIndexOutOfBoundsException e) {
      return 0;
    }
  }

  public void setPeriod(int p) {
    this.patternPeriod = p;
  }
  public void setScale(float s) {
    this.patternScale = s;
  }  
  public void setPatternCenter(PVector p) {
    this.patternCenter = new PVector(p.x / downSample, p.y / downSample);
  }
  public void setPattern(int i) {
    this.pattern = i;
  }
  public void nextPattern() {
    this.pattern = (this.pattern+1) % 6;
    println(this.pattern);
  }
  public void previousPattern() {
    this.pattern = (this.pattern-1) % 6;
    if(this.pattern < 0) this.pattern = 5;
    println(this.pattern);
  }
}


