public class Light {
  private PVector position;
  private Surface surf;
  private float value;
  private float minValue;
  private float maxValue;
  static final float DEFAULT_MIN = 0;
  static final float DEFAULT_MAX = 255;
  
  private int id;
  
  private float size;
  static final float DEFAULT_SIZE = 18;
  
  public Light(int id, PVector p, Surface surf, float min, float max, float s) {
    this.id = id+1;
    this.position = p.get();
    this.minValue = min;
    this.maxValue = max;  
    this.size = s;
    this.surf = surf;
  }
  
  public Light(int id, PVector p, Surface surf, float s) {
    this.id = id+1;
    this.position = p.get();
    this.minValue = DEFAULT_MIN;
    this.maxValue = DEFAULT_MAX;
    this.size = s;    
    this.surf = surf;
  }
  
  public Light(int id, PVector p, Surface surf) {
    this.id = id+1;
    this.position = p.get();
    this.minValue = DEFAULT_MIN;
    this.maxValue = DEFAULT_MAX;
    this.size = DEFAULT_SIZE;    
    this.surf = surf;
  }
 
  public void update() {
    this.value = surf.sampleAt((int)this.position.x, (int)this.position.y);
  }
  
  public void draw() {
    fill(value);
    stroke(50);
    ellipse(position.x, position.y,  this.size, this.size);
  }
  
  public PVector getPosition() {
    return this.position.get();  
  }
  public void setPosition(float x, float y) {
    this.position = new PVector(x,y);
  }
  
  public float getValue() { return this.value; }
  public void setValue(float v) {
    this.value = v;
    constrain(this.value, minValue, maxValue);
  }
  
  public int getID() { return this.id; }
  
  public float getSize() { return this.size; }
  public void  setSize(float s) { this.size = abs(s); }
}
