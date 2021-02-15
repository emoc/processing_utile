/* 
  Exemples d'une structure de jeu avec différents états :
    écran de démarrage, partie, partie gagnée, fin et restart
    + sauvegarde du high-score dans un fichier texte
     
  Nantes, EDNA, workshop joypad, 5 mars 2019
  Processing 3.4 @ kirin / Debian Stretch 9.5
  Pierre Commenge / pierre@lesporteslogiques.net / http://github.com/emoc
  Licence CC0 : https://creativecommons.org/publicdomain/zero/1.0/deed.fr

 */

int mode_jeu = 0;
boolean mode_init = false;
int credits = 0;
int highscore = 0;
String[] highscoreload;
int score1 = 0;
int score2 = 0;
int compteur;
int compteur_max = 6666; // Durée d'une partie en millisecondes

int start_partie;
int time, time_last, time_start;

void setup () {
  size(400, 300);
  highscoreload = loadStrings("highscore.txt");
  highscore = Integer.parseInt(highscoreload[0]);
}

void draw() {
  background(0);
  
  // ********************************************************************
  if (mode_jeu == 0) {        // Ecran de démarrage

    afficherFond();
    afficherCredits();
    afficherTitre();
    afficherHighScore();
    afficherScore1();
    afficherScore2();
  
  // ********************************************************************
  
  } else if (mode_jeu == 1) { // Déroulement de la partie
    if (mode_init) { // A exécuter uniquement une fois en début de partie
      initialiser();
      score1 = 0;
      score2 = 0; 
      time_start = millis();
      //time_last = 0;
      mode_init = false;
    }
    afficherCredits();
    afficherHighScore();
    afficherScore1();
    afficherScore2();
    compteur = millis() - time_start;
    afficherCompteur();
    if (compteur > compteur_max) {
      mode_jeu = 2;
      mode_init = true;
    }
    
  // ********************************************************************
  
  } else if (mode_jeu == 2) { // Partie terminée
    if (mode_init) {
      time_start = millis();
      mode_init = false;
    }
    afficherCredits();
    afficherScore1();
    afficherScore2();
    int max_partie = 0;
    if (score1 > score2) {
      max_partie = score1;
      afficherGagnant(1);
    } else if (score1 < score2) {
      max_partie = score2;
      afficherGagnant(2);
    } else {
      max_partie = score1;
      afficherGagnant(3);
    }
    if (max_partie > highscore) {
      highscore = max_partie;
      String[] highscoresave = new String[]{str(highscore)};
      //String[] highscoresave = " " ;
      saveStrings("highscore.txt", highscoresave);
    }
    afficherHighScore();
    
    if (millis() - time_start > 3333) {
      textSize(14);
      if (credits == 0) text("insérez des crédits (touche c)", width/2, height/2 + 84);
      text("démarrez une partie avec espace", width/2, height/2 + 102);
    }
    if (millis() - time_start > 9999) mode_jeu = 0;
    
  } 
}


void initialiser() {
  compteur = compteur_max;
}

void afficherFond() {
  stroke(255);
  for (int i = 0; i < 20; i++) {
    float y = random(height);
    line(0, y, width, y);
  }
}

void afficherCredits() {
  fill(255);
  textSize(12);
  textAlign(LEFT, BOTTOM);
  text("CREDIT " + credits, width - 100, height - 10);
}

void afficherHighScore() {
  fill(255);
  textSize(18);
  textAlign(CENTER, BOTTOM);
  text("HI-SCORE", width / 2, 20);
  text(highscore, width / 2, 35);
}

void afficherScore1() {
  fill(255);
  textSize(18);
  textAlign(CENTER, BOTTOM);
  text("1 UP", width / 6, 20);
  text(score1, width / 6, 38);
}

void afficherScore2() {
  fill(255);
  textSize(18);
  textAlign(CENTER, BOTTOM);
  text("2 UP", width / 6 * 5, 20);
  text(score2, width / 6 * 5, 38);
}

void afficherTitre() {
  fill(255);
  textSize(64);
  textAlign(CENTER, BOTTOM);
  text("CLLLC", width/2, height/2);
  textSize(14);
  text("6666 millisecondes de clics", width/2, height/2 + 30);
  text("joueur 1 clic gauche", width/2, height/2 + 48);
  text("joueur 2 clic droit", width/2, height/2 + 66);
  if (credits == 0) text("insérez des crédits (touche c)", width/2, height/2 + 84);
  text("démarrez une partie avec espace", width/2, height/2 + 102);
  
}

void afficherGagnant(int gagnant) {
  fill(255);
  textSize(48);
  textAlign(CENTER, BOTTOM);
  if (gagnant == 1) text("PLAYER 1 WIN", width/2, height/2);
  if (gagnant == 2) text("PLAYER 2 WIN", width/2, height/2);
  if (gagnant == 3) text("ALL PLAYERS WIN", width/2, height/2);
}

void afficherCompteur() {
  fill(255);
  textSize(64);
  textAlign(CENTER, BOTTOM);
  text(compteur_max - compteur, width/2, height/2);
}

void afficherGameOver() {
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width/2, height/2);
}

void afficherWin() {
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("WIN", width/2, height/2);
}


void keyPressed() {
  if (key == 'c') credits ++;
  if ((key == ' ') && (credits > 0) && ((mode_jeu == 0) || (mode_jeu == 2)) ) { // Début de la partie
    credits --;
    mode_init = true;
    mode_jeu = 1;
  }
}

void mousePressed() {
  if (mode_jeu == 1) {
    if (mouseButton == LEFT) score1 += 10;
    if (mouseButton == RIGHT) score2 += 10;
  }
}
