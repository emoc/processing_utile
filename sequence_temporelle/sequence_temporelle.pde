/*
  Comment dérouler une séquence temporelle prédéfinie ?
 
  processing 3.5.4 @ kirin / Debian Stretch 9.5
  20210215 KP / Pierre Commenge / pierre@lesporteslogiques.net / http://github.com/emoc
  Licence CC0 : https://creativecommons.org/publicdomain/zero/1.0/deed.fr
 
  Une séquence comprend plusieurs étapes, quand la séquence est terminée, elle reprend au début
 
  Une séquence : 
    0 - 5000ms      : un carré vert s'affiche 5 secondes
    5000 - 10000ms  : un cercle rouge s'affiche 5 secondes
    10000 - 20000ms : un cercle bleu clignotant s'affiche 10 secondes
    retour au début
 
  Les actions correspondantes sont déclenchées à chaque étape de la séquence 
  A chaque action correspond une fonction dédiée
 */

int etape = 0;        // variable pour stocker l'état

// Début de chaque nouvelle séquence en temps absolu
long[] sequence = {0, 5000, 10000, 20000};  

// Variables temporelles de séquence
long sequence_start; // moment dans le déroulement du programme où la séquence a démarré (relatif au programme)
long sequence_now;   // où en est on dans le déroulement de la séquence ? (relatif à la séquence)

// Variables temporelles pour les étapes
long etape_start;    // moment dans la séquence où l'étape démarre (relatif à la séquence)
long etape_end;      // moment dans la séquence où l'étape s'arrête (relatif à la séquence)
long etape_duree;    // durée de l'étape

void setup() {
  size(600, 600);
}

void draw() {
  
  background(0);
  
  // Initialiser uniquement au premier passage dans la boucle draw()
  if (frameCount == 1) initialiserDebutSequence();
  
  // Chercher où on en est dans la séquence *****************************
  sequence_now = millis() - sequence_start;

  for (int i = 0; i <  sequence.length - 1; i++) {
    if (sequence_now > sequence[i] && sequence_now <= sequence[i+1] ) {
      etape = i;
      etape_start = sequence[i];
      etape_end = sequence[i+1];
    } 
    if (sequence_now > sequence[sequence.length-1]) {
      initialiserDebutSequence(); // La séquence est terminée, on la redéclenche 
    }
    etape_duree = etape_end - etape_start;
  }

  // Déclencher les actions **********************************************
  switch(etape) {
   case 0:
   afficherCarreVert();
   break;
   case 1:
   afficherCercleRouge();
   break;
   case 2:
   afficherCercleBleuClignotant();
   break;
  }
  
  // Afficher les infos **************************************************
  fill(255);
  textSize(48);
  textAlign(CENTER, BOTTOM);
  text("étape : " + etape, width/2, height * 0.75 );
  textSize(16);
  text("temps écoulé dans la séquence : " + int(sequence_now), width/2, height * 0.75 + 50);
  text("étape débutée à : " + int(etape_start), width/2, height * 0.75 + 75);
  text("durée étape : " + int(etape_duree), width/2, height * 0.75 + 100);
  text("temps écoulé total : " + millis(), width/2, height * 0.75 + 125);
}

void initialiserDebutSequence() {
  sequence_start = millis();
}

void afficherCarreVert() {
  fill(0, 255, 0);
  noStroke();
  rectMode(CENTER);
  rect(width/2, height * 0.25, height * 0.33, height * 0.33);
}

void afficherCercleRouge() {
  fill(255, 0, 0);
  noStroke();
  ellipseMode(CENTER);
  ellipse(width/2, height * 0.25, height * 0.33, height * 0.33);
}

void afficherCercleBleuClignotant() {  
  fill(0, 0, 255 * sin(frameCount * 0.3));
  noStroke();
  ellipseMode(CENTER);
  ellipse(width/2, height * 0.25, height * 0.33, height * 0.33);
}
