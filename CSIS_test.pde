Surface surf;
ArrayList<Light> lights;
boolean drawSurf = true;

void setup() {
  size(800,600);
  surf = new Surface(width, height);
  lights = new ArrayList<Light>();
  for(int i=0; i<425; i++) {
    PVector p = new PVector(width/2 - i%20*20 + 200, height/2 - i/20*20 + 200);
    println(p);
    lights.add(new Light(p, surf));
  }
}

void draw() {
  background(0);
  surf.update();
  if(drawSurf)
    surf.draw();
  for(int i=0; i<lights.size(); i++) {
    lights.get(i).update();
    lights.get(i).draw();
  }
  
}

void keyPressed() {
  if(key == CODED) {
    switch(keyCode) {
      case RIGHT:
        surf.nextPattern();
        break;
      case LEFT:
        surf.previousPattern();
        break;
    }
  } 
  else if(key == 's') {
    drawSurf = !drawSurf;
  }
}
