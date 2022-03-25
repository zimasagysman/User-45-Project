
Table table;
int len;              //length of the dataset
float angleInc;       //angle of rotation around the ellipse for each artist
float pos = 200;      //starting position of writing each artist name
float margin = 10;    //distance from edge of the ellipse

void setup() {
  size (displayWidth, displayHeight);
  background(#d6caf0);
  table = loadTable("artistfreq.csv");
  //println(table.getRowCount() + " total rows in table"); 

  len = table.getRowCount();
  angleInc = TAU/len;
}

void draw() {
  pushMatrix();
  background(#d6caf0);

  translate(width/2, height/2);
  noFill();
  ellipseMode(CENTER);
  textAlign(LEFT);
  stroke(#7e3e78);
  ellipse(0, 0, pos * 2, pos * 2);

  PVector mouseVector = new PVector(mouseX, mouseY);
  mouseVector.sub(new PVector(width/2, height/2));    //adding two vectors to translate movement around the ellipse
  float mouseAngle = -mouseVector.heading();          //calculates vector position of the cursor
  //println(mouseAngle);
  //println(PVector.angleBetween(mouseVector, xVector));

  float minAngleDiff = TAU;      //the angle difference between the cursor and the closest artist name
  int closestArtistId = 0;       

  for (int i = 0; i < len; i++) {
    pushMatrix();
    float artistAngle = i * angleInc;
    rotate(artistAngle);
    TableRow r = table.getRow(i);
    String[] artistAndPlays = split(r.getString(0), '\t');
    fill(0);
    textAlign(LEFT);
    textSize(10);
    text(artistAndPlays[0], pos + margin, 0);    //artist name rotating around ellipse

    popMatrix();

    PVector artistVector = new PVector(cos(artistAngle), sin(artistAngle));    //from polar to vector
    float d = PVector.angleBetween(artistVector, mouseVector);                 //d tracks the cursor position
    //println(d);
    if (d < minAngleDiff) {
      minAngleDiff = d;
      closestArtistId = i;
    }
  }
  fill(#d6caf0);
  stroke(#7e3e78);
  float p = 200;                                  //radius of the ellipse

  ellipse(p * cos(closestArtistId * angleInc), p * sin(closestArtistId * angleInc), margin, margin);
  textAlign(CENTER);
  textSize(80);
  fill(#FFFF99);
  TableRow r = table.getRow(closestArtistId);
  String[] artistAndPlays = split(r.getString(0), '\t');
  text(artistAndPlays[1], 0, 20);              //number of plays for that artist


  //    TO CHECK THE SELECTED ARTIST
  //TableRow r = table.getRow(closestArtistId);
  //String[] name = split(r.getString(0), '\t');
  //println(name[0]);

  popMatrix();
}
