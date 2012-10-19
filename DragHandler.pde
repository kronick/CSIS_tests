
Light lightDragging = null;

void mousePressed() {
  Light l;
  lightDragging = null;
  for(int i=0; i<lights.size(); i++) {
    l = lights.get(i);
    PVector p = l.getPosition();
    if(sqrt(sq(mouseX - p.x) + sq(mouseY - p.y)) < l.getSize() * 1.2) {
      lightDragging = l;
    }
  }  
  
  if (lightDragging == null) {
    surf.setPatternCenter(new PVector(mouseX, mouseY));  
  }
}

void mouseDragged() {
  if(lightDragging != null) {
    lightDragging.setPosition(mouseX, mouseY);
  }  
}

void mouseReleased() {
  lightDragging = null;
}
