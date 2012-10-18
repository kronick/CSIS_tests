public class Surface {
  PImage img;
  boolean pixelsLoaded = false;

  int pattern;
  PVector patternCenter;
  int patternStep = 0;
  int patternPeriod = 60;
  static final int GRADIENT_LEFT_RIGHT = 0;
  static final int GRADIENT_TOP_BOTTOM = 1;
  static final int GRADIENT_RADIAL = 2;
  static final int RIPPLE = 3;
  static final int WHITE_NOISE = 4;
  static final int PERLIN_NOISE = 5;
  
  public Surface(int w, int h) {
    img = createImage(w, h, ALPHA);
    patternCenter = new PVector(w/2, h/2);
    pattern = RIPPLE;
  }
  
  public void update() {
    patternStep++;
    if(patternStep > patternPeriod) patternStep = 0;
    img.loadPixels();
    float val = 0;
    for(int x=0; x<img.width; x++) {
      for(int y=0; y<img.height; y++) {
        switch(pattern) {
          case GRADIENT_LEFT_RIGHT:
            val = abs(0.5 - abs((x/(float)img.width - patternStep/(float)patternPeriod) % 1));
            break;
          case GRADIENT_TOP_BOTTOM:
            val = abs(0.5 - abs((y/(float)img.height - patternStep/(float)patternPeriod) % 1));
            break;        
          case RIPPLE:
            val = cos(sqrt(sq(patternCenter.x - x) + sq(patternCenter.y - y)) / 20. + (TWO_PI*patternStep/(float)patternPeriod)) / 2. + 0.5;
            break;
          case WHITE_NOISE:
            val = patternStep == 0 ? random(0,1) : (img.pixels[y*img.width + x] / 255.);
            break;
          case PERLIN_NOISE:
            val = noise(x/(float)width*5, y/(float)height*5, frameCount/(float)patternPeriod*10.);
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
    this.draw(0,0,img.width, img.height);  
  }
  
  public void draw(int Px, int Py, int w, int h) {
    tint(255);
    image(img, Px, Py, w, h);
  }
  
  public int sampleAt(int x, int y) {
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
  public void setPatternCenter(PVector p) {
    this.patternCenter = p.get();
  }
  public void setPattern(int i) {
    this.pattern = i%5;
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


