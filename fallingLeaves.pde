//***************************************************************
//falling leaves app
//***************************************************************
static final boolean DEBUG_MODE = true;
static boolean display_background = true;
static PImage imgBackground = null;
static GridTiler gridTiles;
float lastEndTick = 0;

static boolean edit_mode = false;

static LeafSystem leafs;

//***************************************************************
// called to set everything up
//***************************************************************
void setup()
{
  if(DEBUG_MODE)
  { size(600,800,P2D); }
  else
  { size(800,600,P2D); }//we are dealing with a 800x600 native res projector
  
  XML xml = loadXML("GridTiler.xml");
  if(DEBUG_MODE)
  { gridTiles = new GridTool(xml);}//new float[]{width/2,height/2},50, PI/3, 2*PI/3.f);
  else
  { gridTiles = new GridTiler(xml); }
 
  gridTiles.loadWithXML(xml);
  
  leafs = new LeafSystem(20);
}

void drawBackground()
{
  pushMatrix();
  if(DEBUG_MODE)
  { 
    translate(0,width);
    rotate(-PI/2);
  }  
  if (null == imgBackground) {
    imgBackground = loadImage("treeoverlay.png");
  }
  image(imgBackground, 0, 0, width, height);
  
  popMatrix();
}

//***************************************************************
// our looping function called once per tick
// resposible for drawing AND updating... everything
//***************************************************************
void draw()
{
  if(DEBUG_MODE)
  { 
    pushMatrix();
    translate(width,0);
    rotate(PI/2);
  }
  background(50);

  if (display_background) {
    drawBackground();
  }

  float secondsSinceLastUpdate = (millis()-lastEndTick)/1000.f;
  gridTiles.update(secondsSinceLastUpdate);
  gridTiles.draw();
  lastEndTick = millis();
  
  if (DEBUG_MODE) {
    popMatrix();
    leafs.displaySpawnData();
  }
}

//***************************************************************
// super basic input
//***************************************************************
void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  if (edit_mode) {
    leafs.addSpawnPoint(x, y);
  }
}

void mouseDragged() {
  int x = mouseX;
  int y = mouseY;
  if (edit_mode) {
    leafs.addSpawnPoint(x, y);
  }
}

void saveScreenToPicture()
{
  saveFrame("screenCapture.png");
}

void keyPressed()
{
  if ((key == 'p') || (key == 'P')) {
    saveScreenToPicture();
  }
  if ((key == 'g') || (key == 'G')) {
    if(DEBUG_MODE)
      ((GridTool)gridTiles).generateCutouts();
  }
  if ((key == 'b') || (key == 'B')) {
    display_background ^= true;
  }
  if ((key == 'e') || (key == 'E')) {
    edit_mode ^= true;
  }
}
