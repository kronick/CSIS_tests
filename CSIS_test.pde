import controlP5.*;
import dmxP512.*;
import processing.serial.*;

Surface surf;
ArrayList<Light> lights;
boolean drawSurf = false;
boolean drawIDs = false;

ControlP5 cp5;

int arrangement;
static final int SMALL_GRID = 0;
static final int BIG_GRID = 1;
static final int WORLD_MAP = 2;
float lightSpacing = 15;
float lightSize = 10;

static final String MAP_FILE = "world_grid_425.svg";

PFont labelFont;

// DMX Output
boolean dmxOutputEnabled = false;
DmxP512 dmxOutput;
static final int DMXPRO_UNIVERSE_SIZE = 128;
static final String DMXPRO_PORT = "/dev/cu.usbserial-EN110442";  // Must change to match your machine's serial port
static final int DMXPRO_BAUDRATE = 115000;

void setup() {
  size(1024,768);
  surf = new Surface(width, height);
  arrangement = BIG_GRID;
  changeArrangement(arrangement);
  
  cp5 = new ControlP5(this);
  
  setupGUI();
  
  dmxOutput = new DmxP512(this, DMXPRO_UNIVERSE_SIZE, false);
  if(dmxOutputEnabled) {
    try {
      dmxOutput.setupDmxPro(DMXPRO_PORT, DMXPRO_BAUDRATE);
      dmxOutputEnabled = true;
    }
    catch(Exception e) {
      println("Couldn't open port for DMX output: " + e);
      dmxOutputEnabled = false;
    }
  }
  
  labelFont = loadFont("HelveticaNeueLTCom-MdCn-12.vlw");
  textFont(labelFont, 10);
  textAlign(CENTER, CENTER);
  
  frameRate(60);
}

void changeSpacing(float s) {
  lightSpacing = s;
  changeArrangement(arrangement, false);  
}
void changeLightSize(float s) {
  lightSize = s;
  for(Light l : lights) {
    l.setSize(lightSize);
  }
}

void changeArrangement(int a) {
  changeArrangement(a, true);
}
void changeArrangement(int a, boolean setSpacingSize) {
  arrangement = a;
  switch(a) {
    case SMALL_GRID:
      // Make a 3x3 grid in the middle
      if(setSpacingSize) { lightSize = 90; lightSpacing = 150; }
      lights = new ArrayList<Light>();
      float spacing = lightSpacing;
      float w = spacing * 2;
      for(int i=0; i<9; i++) {
        PVector p = new PVector(width/2 - w/2 + i%3*spacing, height/2 - w/2 + i/3*spacing);
        lights.add(new Light(i, p, surf, lightSize));
      }
      break;
    case BIG_GRID:
      // Make a 25x16 grid in the middle
      if(setSpacingSize) { lightSize = 18; lightSpacing = 30; }
      lights = new ArrayList<Light>();
      spacing = lightSpacing;
      w = spacing * 24;
      float h = spacing * 15;
      for(int i=0; i<400; i++) {
        PVector p = new PVector(width/2 - w/2 + i%25*spacing, height/2 - h/2 + i/25*spacing);
        lights.add(new Light(i, p, surf, lightSize));
      }    
      break;
    case WORLD_MAP:
      // Load from SVG/XML file that contains circles at light positions
      lights = new ArrayList<Light>();  
      if(setSpacingSize) { lightSize = 6; lightSpacing = 30; }
      try {
        // XML xml = new XML(this, MAP_FILE);
        // Workaround to avoid NPE's via https://forum.processing.org/topic/problems-getting-to-work-xml-class-in-processing-2-0#25080000001259021
        String lines[] = loadStrings(MAP_FILE);
        String oneLine = join(lines,"").replace("> <","><");
        XML xml = XML.parse(oneLine);
        
        String widthString = xml.getString("width");
        String heightString = xml.getString("height");
        w = parseInt(widthString.substring(0,widthString.length()-2));
        h = parseInt(heightString.substring(0,widthString.length()-2));
        XML[] children = xml.getChildren();
        for(int i=0; i<children.length; i++) {
          XML el = children[i];
          if(el.getName().equals("circle")) {
            float scaleFactor = width/w * lightSpacing / 40.0;
            PVector p = new PVector(el.getInt("cx"), el.getInt("cy"));
            p.mult(scaleFactor);
            p.add(new PVector(width/2 - w/2*scaleFactor, height/2 - h/2*scaleFactor));
            lights.add(new Light(i, p, surf, lightSize));
          }
          else {
            println("Element not a circle: " + el.toString());
          }  
        }
        println("w: " + w + " h: " + h);
      }
      catch(Exception e) {
        println("Couldn't open XML map file: " + e);
      }
      break;
  }
}

void draw() {
  background(0);
  surf.update();
  if(drawSurf)
    surf.draw();
  for(Light l : lights) {
    l.update();
    if(dmxOutputEnabled) {
      dmxOutput.set(l.getID(), (int)l.getValue());
    }
    l.draw();
    if(drawIDs) {
      fill(200);
      text(l.getID(), l.getPosition().x, l.getPosition().y);
    }
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
