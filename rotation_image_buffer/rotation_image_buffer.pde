/*
  Rotation de l'image dans un buffer et sauvegarde du buffer
  Quimper, 28 février 2022 / pierre@lesporteslogiques.net
  Processing 4.0b2 @ kirin, debian stretch 9.5
  
  Changer l'orientation de l'image de la fenêtre pour l'enregistrer
  Utilise l'objet g de processing (PGraphics dans lequel processing dessine 
    ce qui est affiché dans la fenêtre principale)
*/

PGraphics image_rot;

void setup() {
  size(400, 600);
  image_rot = createGraphics(height, width);
}

void draw() {
  background(255);
  fill(0);
  textSize(600);
  text("R", 30, 500);
  PGraphics ir1 = rotationBuffer(1);
  ir1.save("rot1.jpg");
  PGraphics ir2 = rotationBuffer(2);
  ir2.save("rot2.jpg");
  PGraphics ir3 = rotationBuffer(3);
  ir3.save("rot3.jpg");
  noLoop();
}

/*
   image originale : [v]
   orientation 1, renvoie [>]
   orientation 2, renvoie [<]
   orientation 3 : renvoie [^]
*/
PGraphics rotationBuffer(int orientation) {
  PGraphics ir;
  if (orientation == 1) {
    ir = createGraphics(height, width);
    ir.beginDraw();
    ir.translate(0, width);
    ir.rotate(radians(270));
    ir.image(g, 0, 0);
    ir.endDraw();
  } else if (orientation == 2) {
    ir = createGraphics(height, width);
    ir.beginDraw();
    ir.translate(height, 0);
    ir.rotate(radians(90));
    ir.image(g, 0, 0);
    ir.endDraw();
  } else if (orientation == 3) {
    ir = createGraphics(width, height);
    ir.beginDraw();
    ir.translate(width, height);
    ir.rotate(radians(180));
    ir.image(g, 0, 0);
    ir.endDraw();
  } else {
    ir = createGraphics(width, height);
  }
  return ir;
}
