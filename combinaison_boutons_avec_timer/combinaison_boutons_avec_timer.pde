/*
  Appuyer sur des boutons, ou des combinaisons de boutons, dans un temps réduit
  
  EDNA, Workshop code créatif I2 2020-2021, 4-8 jan 2021
  Pierre Commenge / pierre@lesporteslogiques.net / http://github.com/emoc
  Licence CC0 : https://creativecommons.org/publicdomain/zero/1.0/deed.fr
  
  Processing 3.5.4  
    + lib. CountdownTimer 0.9.4 de Dong Hyun Choi : https://github.com/dhchoi/processing-countdowntimer
       (installable depuis le gestionnaire bibliothèque de processing)
    
  Avec une méthode pour retirer x éléments aléatoires différents dans un ensemble utilisant IntList
 */

// Import et objets pour l'utilisation des timers
import com.dhchoi.CountdownTimer;
import com.dhchoi.CountdownTimerService;
CountdownTimer timer;
String timerCallbackInfo = "";
int temps_reponse = 2000;   // en millisecondes

// Elements du jeu
boolean[] bouton_cible = {false, false, false, false, false, false};
boolean[] bouton_user  = {false, false, false, false, false, false};
int score_global = 0;
IntList valeurs;       // liste des valeurs pour tirages aléatoires multiples
int nb_boutons_actifs; // nombre de boutons actifs varie en fonction du niveau de jeu

// Liste des touches (pour l'affichage)
String[] touche = {"w", "x", "c", "v", "b", "n"};


void setup() {
  size(700, 400);
  textSize(20);
  
  // Créer la liste de toutes les valeurs possibles pour les tirages aléatoires
  valeurs = new IntList();
  valeurs.append(0);
  valeurs.append(1);
  valeurs.append(2);
  valeurs.append(3);
  valeurs.append(4);
  valeurs.append(5);
  
  // Configuration du timer
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(100, temps_reponse);
}

void draw() {
  background(255);
  fill(0);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  
  // Démarrer avec un combo toujours gagnant !
  if (frameCount == 1) {
    for (int i=0; i<6; i++) {
      bouton_cible[i] = false;
      bouton_user[i] = false;
    }
    timer.start();
  }

  // Afficher les boutons cible (touches à presser)
  for (int i=0; i<6; i++) {
    if (bouton_cible[i] == false) {
      fill(127);
    } else {
      fill(255, 255, 0);
    }
    rect(100 + i*100, 100, 40, 40);
    fill(0);
    text(touche[i], 100 + i*100, 100);
  }

  // Afficher les boutons user (touches déjà pressées)
  for (int i=0; i<6; i++) {
    if (bouton_user[i] == false) {
      fill(127);
    } else {
      fill(255, 255, 0);
    }
    rect(100 + i*100, 200, 40, 40);
    fill(0);
    text(touche[i], 100 + i*100, 200);
  }

  // Quel temps reste t'il ?
  textAlign(LEFT, CENTER);
  text("temps restant : " + timerCallbackInfo, 100, 300);
  
  // Et le score ?
  text("SCORE : " + score_global, 100, 40);
  
  // Aide-mémoire ?
  text("utiliser les touches : w, x, c, v, b, n" , 250, 350);
}

// Fonction de callback appelée à chaque "tick" configuré dans le timer
void onTickEvent(CountdownTimer t, long timeLeftUntilFinish) {
  timerCallbackInfo = timeLeftUntilFinish + " ms";
}

// Fonction de callback appellée à la fin du timer
void onFinishEvent(CountdownTimer t) {
  timerCallbackInfo = "[fini]";
  comparerResultats();
  nouveauTirage();
  redemarrerTimer();
}

// Une fois le temps écoulé, on compare les résultats
void comparerResultats() {
  int score = 0;
  for (int i=0; i<6; i++) {
    if (bouton_cible[i] == bouton_user[i]) score ++;
  }
  // Les points sont comptés uniquement si tout est correct!
  if (score == 6) {
    score_global += nb_boutons_actifs;
  } else {
    score_global -= nb_boutons_actifs;
  }
}

// Redémarrer avec un nouveau tirage aléatoire
void nouveauTirage() {
  // Remettre tout à zéro
  for (int i=0; i<6; i++) {
    bouton_cible[i] = false;
    bouton_user[i] = false;
  }
  
  // Combien de boutons sont à activer ?
  nb_boutons_actifs = int((score_global / 10) + 1);
  if (nb_boutons_actifs > 4) nb_boutons_actifs = 4; // On ne dépasse jamais 4 boutons maximum 
  if (nb_boutons_actifs < 1) nb_boutons_actifs = 1; // On ne descend jamais en dessous d'un bouton 
  
  // Choix aléatoire des valeurs
  valeurs.shuffle(); // mélanger les valeurs
  for (int j=0; j < nb_boutons_actifs; j++) { // Choisir x valeurs selon le niveau
    int t = valeurs.get(j);
    bouton_cible[t] = true;
  } 
}

void redemarrerTimer() {
  timer = CountdownTimerService.getNewCountdownTimer(this).configure(100, temps_reponse);
  timer.start();
}

void keyPressed() {
  if (key == 'w') bouton_user[0] = true;
  if (key == 'x') bouton_user[1] = true;
  if (key == 'c') bouton_user[2] = true;
  if (key == 'v') bouton_user[3] = true;
  if (key == 'b') bouton_user[4] = true;
  if (key == 'n') bouton_user[5] = true;
}
