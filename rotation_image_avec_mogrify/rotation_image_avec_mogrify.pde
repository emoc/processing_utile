/*
 Rotation de l'image en appelant une commande extérieure (mogrify)
 Quimper, 1 mars 2022 / pierre@lesporteslogiques.net
 Processing 4.0b2 @ kirin, debian stretch 9.5
 
 Changer l'orientation de l'image de la fenêtre après l'enregistrement
 
 (pas trouvé de solution pour faire une rotation de buffer dans processing
 quand on utilise des shaders, d'où l'appel à une commande extérieure
 */


void setup() {
  size(400, 600);
}

void draw() {
  background(255);
  fill(0);
  textSize(600);
  text("R", 30, 500);
  String imagefilename = "image.jpg";
  save(imagefilename);
  rotationBufferMogrify(3, imagefilename);
  noLoop();
}

/*  Rotation d'iamge en appelant une commande externe : mogrify
 Le fichier d'origine est remplacé par la version pivotée
 image originale : [v]
 orientation 1, renvoie [>]
 orientation 2, renvoie [<]
 orientation 3 : renvoie [^]
 */

void rotationBufferMogrify(int orientation, String imagefilename) {

  if (orientation == 1) {
    Process p = exec("/usr/bin/mogrify", "-rotate", "270", sketchPath(imagefilename));
    try {
      int result = p.waitFor();
      println("the process returned " + result);
    }
    catch (InterruptedException e) {
    }
  } else if (orientation == 2) {
    Process p = exec("/usr/bin/mogrify", "-rotate", "90", sketchPath(imagefilename));
    try {
      int result = p.waitFor();
      println("the process returned " + result);
    }
    catch (InterruptedException e) {
    }
  } else if (orientation == 3) {
    Process p = exec("/usr/bin/mogrify", "-rotate", "180", sketchPath(imagefilename));
    try {
      int result = p.waitFor();
      println("the process returned " + result);
    }
    catch (InterruptedException e) {
    }
  }
}
