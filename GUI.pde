void setupGUI() {
  // Styling
  cp5.setFont(loadFont("HelveticaNeueLTCom-MdCn-12.vlw"));
  cp5.setColor(new CColor(color(180), color(80), color(255), color(255), color(255)));
  
  // Grid properties
  // -----------------------------------------------------  
  cp5.addRadioButton("changeArrangement")
     .setPosition(30, height-90)
     .setSize(20,20)
     .setItemsPerRow(3)
     .setSpacingColumn(80)
     .addItem("Small Grid", SMALL_GRID)
     .addItem("Large Grid", BIG_GRID)
     .addItem("World Map", WORLD_MAP);
  
  cp5.addSlider("changeSpacing")
     .setPosition(30, height-60)
     .setSize(160,20)
     .setRange(5,200)
     .setValue(15)
     .setCaptionLabel(" Spacing"); 
  
  cp5.addSlider("changeLightSize")
     .setPosition(30, height-30)
     .setSize(160,20)
     .setRange(1,100)
     .setValue(10)
     .setCaptionLabel(" Light Size");      
     
  // Surface Pattern properties
  // ---------------------------------------------------
  cp5.addRadioButton("changePattern")
     .setPosition(width/2+30, height-90)
     .setSize(20,20)
     .setItemsPerRow(6)
     .setSpacingColumn(60)
     .addItem("L->R", Surface.GRADIENT_LEFT_RIGHT)
     .addItem("Diagonal", Surface.GRADIENT_CORNER)
     .addItem("Ripple", Surface.RIPPLE)
     .addItem("Random", Surface.WHITE_NOISE)
     .addItem("Perlin", Surface.PERLIN_NOISE);  
     
  cp5.addSlider("changePatternSpeed")
     .setPosition(width/2+30, height-60)
     .setSize(160,20)
     .setRange(0,20)
     .setValue(5)
     .setCaptionLabel(" Speed");
  cp5.addSlider("changePatternScale")
     .setPosition(width/2+240, height-60)
     .setSize(160,20)
     .setRange(0.1,10)
     .setValue(1)
     .setCaptionLabel(" Scale");     
  
  cp5.addToggle("drawSurf", drawSurf, width/2+30, height-30, 20,20)
     .setCaptionLabel(" Draw Surface");
  cp5.getController("drawSurf").getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, ControlP5.CENTER);
}

void changePattern(int i) {
  surf.setPattern(i);
}
void changePatternScale(float s) {
  surf.setScale(s);
}
void changePatternSpeed(float s) {
  surf.setPeriod((int)(60.0/(s/5.0)));
  println((int)(60.0/(s/5.0)));
}

/*
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(cp5.getController("arrangementType"))) {
    
  }  
}
*/


