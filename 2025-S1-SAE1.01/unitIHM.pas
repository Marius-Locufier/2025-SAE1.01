unit unitIHM;

{Le role de cette unit est de gérer toute la partie interface homme machine majeurs}

interface
  //fonction qui affiche le menu et renvoie le choix de l'utilisateur
  function menuIHM():Integer;

  //procedure pour quitter l'interface
  procedure quitterIHM();

  //procédure pour afficher le titre du jeu avant le menu
  procedure ecranTitreIHM();

  procedure RencontreMadameSologny();

  
implementation
uses
  GestionEcran, unitLogic, SysUtils, unitINV, unitMission,Musique_bonus;


///////////////////////////////////////////
//procedure affichant l'écran titre
// --- ECRAN TITRE (Version sans CentrerTexte) ---
procedure ecranTitreIHM();
var
  x, y : Integer;
begin
  changerTailleConsole(200, 40);
  effacerEcran();
  
  // 2. Un cadre global propre
  dessinerCadreXY(2, 1, 199, 39, double, LightCyan, Black);
  
  // 3. Affichage du Titre "SATISFACT'IUT"
  couleurTexte(Yellow);
  
  // Calcul du centre : (200 - 86) div 2 = 57
  x := (200 - 86) div 2; 
  y := 10; 

  deplacerCurseurXY(x, y);     writeln('   _____        _____________  _____ ______        _____ _______   _____ _    _ _______ ');
  deplacerCurseurXY(x, y + 1); writeln('  / ____|   /\ |__   __|_   _|/ ____|  ____| /\  /  ____|__   __| |_   _| |  | |__   __|');
  deplacerCurseurXY(x, y + 2); writeln(' | (___    /  \   | |    | | | (___ | |__   /  \ | |       | |      | | | |  | |  | |   '); //affichage du nom du jeux
  deplacerCurseurXY(x, y + 3); writeln('  \___ \  / /\ \  | |    | |  \___ \|  __| / /\ \| |       | |      | | | |  | |  | |   ');
  deplacerCurseurXY(x, y + 4); writeln('  ____) |/ /__\ \ | |   _| |_ ____) | |   / /__\ \ |____   | |     _| |_| |__| |  | |   ');
  deplacerCurseurXY(x, y + 5); writeln(' |_____//_/    \_\|_|  |_____|_____/|_|  /_/    \_\_____|  |_|    |_____|\____/   |_|   ');

  // 4. Ligne de décoration
  deplacerCurseurXY(x, y + 7);
  write('--------------------------------------------------------------------------------------');
  couleurTexte(LightGray);
  deplacerCurseurXY((200 - Length('SIMULATEUR DE GESTION SPATIALE - IUT EDITION')) div 2, 22);
  writeLN('SIMULATEUR DE GESTION SPATIALE - IUT EDITION');
  couleurTexte(LightGray);
  deplacerCurseurXY((200 - Length('Par Hugo BANDERIER, Marius LOCUFIER, Battal SAHIN et Antoine ARMAND')) div 2, 20);  //Ceci permet de centrer parfaitement.
  write('Par Hugo BANDERIER, Marius LOCUFIER, Battal SAHIN et Antoine ARMAND');
  couleurTexte(White);
  dessinerCadreXY(85, 30, 115, 32, simple, DarkGray, Black);
  deplacerCurseurXY((200 - Length('- APPUYEZ SUR ENTREE -')) div 2, 31);
  write('- APPUYEZ SUR ENTREE -');
  deplacerCurseurXY(1, 1); // Cache le curseur
  SonDemarrage();
end;
///////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////

function menuIHM(): Integer;
var
  choix : Integer;
  msgErreur : String;
  txt : String;
begin
  choix := 0;
  msgErreur := '';

  // On s'assure de la taille
  changerTailleConsole(200, 40);

  while (choix <> 1) AND (choix <> 2) do
  begin
    effacerEcran();
    
    // 1. Cadre Global
    dessinerCadreXY(2, 1, 199, 39, double, LightCyan, Black);

    // 2. Titre du Jeu
    dessinerCadreXY(70, 3, 130, 5, simple, LightCyan, Black); 
    couleurTexte(Yellow);
    txt := 'SATISFACT''IUT - SYSTEME D''ACCES';
    deplacerCurseurXY(70 + (60 - Length(txt)) div 2, 4);
    write(txt);

    // ============================================================
    // GAUCHE : LES BOUTONS 
    // ============================================================
    
    // Cadre "Commandes"
    dessinerCadreXY(35, 10, 85, 30, simple, White, Black);
    couleurTexte(LightCyan);
    txt := '[ ACTIONS ]';
    deplacerCurseurXY(60 - (Length(txt) div 2), 10); 
    write(txt);

    // Option 1 : JOUER
    couleurTexte(LightGreen);
    dessinerCadreXY(40, 14, 80, 16, simple, Green, Black);
    txt := '1. INITIALISER LA PARTIE';
    deplacerCurseurXY(40 + (40 - Length(txt)) div 2, 15);
    write(txt);

    // Option 2 : QUITTER
    couleurTexte(LightRed);
    dessinerCadreXY(40, 20, 80, 22, simple, Red, Black);
    txt := '2. DECONNEXION';
    deplacerCurseurXY(40 + (40 - Length(txt)) div 2, 21);
    write(txt);

    // Zone d'erreur 
    if msgErreur <> '' then
    begin
      couleurTexte(Red);
      deplacerCurseurXY(35, 25); 
      write(msgErreur);
    end;

    // ============================================================
    // DROITE : LE MESSAGE 
    // ============================================================
    
    // Cadre "Message"
    dessinerCadreXY(95, 10, 165, 30, simple, White, Black);
    couleurTexte(Yellow);
    txt := '[ MESSAGE ENTRANT ]';
    deplacerCurseurXY(130 - (Length(txt) div 2), 10);
    write(txt);

    // Contenu du message 
    couleurTexte(LightGray);
    deplacerCurseurXY(100, 13); write('DE     : SUPERVISEUR M. SIMONET');
    deplacerCurseurXY(100, 14); write('OBJET  : MISSION MARS');
    deplacerCurseurXY(100, 15); write('DATE   : 2025-S1');
    deplacerCurseurXY(100, 16); write('------------------------------------------------------------');

    // Corps du message
    couleurTexte(White);
    deplacerCurseurXY(100, 18); write('Bienvenue, etudiant.');
    deplacerCurseurXY(100, 20); write('L''IUT a investi beaucoup de DolarsZANI sur vous.');
    deplacerCurseurXY(100, 21); write('Votre fusee est prete. Vos usines attendent.');
    
    deplacerCurseurXY(100, 23); write('Objectifs :');
    couleurTexte(LightCyan);
    deplacerCurseurXY(103, 24); write('> Construire des mines');
    deplacerCurseurXY(103, 25); write('> Gerer l''energie');
    deplacerCurseurXY(103, 26); write('> Ne pas faire faillite');

    couleurTexte(Yellow);
    deplacerCurseurXY(135, 28); write('Bonne chance.');

    // ============================================================
    // BAS : LA SAISIE 
    // ============================================================

    couleurTexte(LightCyan);
    dessinerCadreXY(65, 33, 135, 35, simple, LightCyan, Black);
    deplacerCurseurXY(70, 34); 
    write('VOTRE CHOIX > ');

    couleurTexte(Yellow);
    readln(choix);
  end;
  
  menuIHM := choix;
end;
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////
//procedure qui fait l'apparence de l'écran quitter 
procedure quitterIHM();
begin
  effacerEcran();
  couleurTexte(Red);
  dessinerCadreXY(89,13, 111,15, simple, Red, Black);
  deplacerCurseurXY(91,14);
  write('Merci d''avoir jouer');
  deplacerCurseurXY(1,1);
end;
//////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// --- ÉVÉNEMENT ALÉATOIRE : MADAME Sologny ---
// PROCEDURE : MADAME Sologny (EVENT)
// Description : Un mini-jeu de verbes irréguliers
// Probabilité : 10% à chaque appel.
////////////////////////////////////////////////////////////////////////////////
//EHEH bon courage !!!

procedure RencontreMadameSologny();
var
  chance, i, randVerb : Integer;
  repPreterit, repParticipe : String;
  echec : Boolean;
  // Petit tableau de verbes irréguliers pour le test
  // Base de données des verbes pour le test
  verbes : array[1..10, 1..3] of String = (
    ('BE', 'WAS/WERE', 'BEEN'),
    ('GO', 'WENT', 'GONE'),
    ('EAT', 'ATE', 'EATEN'),
    ('TAKE', 'TOOK', 'TAKEN'),
    ('SEE', 'SAW', 'SEEN'),
    ('DO', 'DID', 'DONE'),
    ('HAVE', 'HAD', 'HAD'),
    ('SPEAK', 'SPOKE', 'SPOKEN'),
    ('WRITE', 'WROTE', 'WRITTEN'),
    ('COME', 'CAME', 'COME')
  );
  inv : ^TRessource; 
 // Pointeur découverte perso ceci permet de modifier directement l'inventaire sans ça l'inventaire du joueur n'aurait pas changer et oui.
begin
  // 1. Tirage au sort (0..99)
  chance := Random(100); 
  
  // Random(100) donne un chiffre entre 0 et 99. Si c'est 0, elle apparaît.
  
  // 
  if (chance <90) then Exit; 
  // L'événement n'a lieu que si chance >= 90 (10% de chance).

  echec := False;
  effacerEcran();
  

  // --- MISE EN SCENE GRAPHIQUE ---
  
  // 2. Cadre Principal (Gauche et Centre) pour l'événement
  dessinerCadreXY(2, 1, 148, 38, double, LightMagenta, Black);

  // 2. Affichage de l'ASCII Art (À droite)
  // 3. Cadre Inventaire (Droite) pour montrer ce qu'on risque de perdre
  dessinerCadreXY(150, 1, 198, 38, double, LightBlue, Black);
  
  // On récupère l'inventaire de la zone active
  inv := @partie.Zones[partie.IndexZoneActive].Inventaire;

  // Affichage de l'inventaire
  couleurTexte(LightBlue);
  deplacerCurseurXY(160, 3); write('VOS RESSOURCES');
  deplacerCurseurXY(155, 4); write('-----------------------');

  couleurTexte(White);
  deplacerCurseurXY(155, 7);  write('Bois      : ', inv^.Bois);
  deplacerCurseurXY(155, 9);  write('Brique    : ', inv^.Brique);
  deplacerCurseurXY(155, 11); write('Cuivre    : ', inv^.Cuivre);
  deplacerCurseurXY(155, 13); write('Titane    : ', inv^.Titane);
  deplacerCurseurXY(155, 15); write('Netherite : ', inv^.Netherite);
  deplacerCurseurXY(155, 17); write('Palladium : ', inv^.Paladium);
  deplacerCurseurXY(155, 19); write('Endium    : ', inv^.Endium);
  
  deplacerCurseurXY(155, 21); write('-----------------------');
  couleurTexte(Yellow);
  deplacerCurseurXY(155, 23); write('DolarsZANI   : ', partie.DolarsZANI);

  // Avertissement danger
  couleurTexte(LightRed);
  dessinerCadreXY(153, 30, 195, 34, simple, Red, Black);
  deplacerCurseurXY(160, 31); write('! ATTENTION !');
  deplacerCurseurXY(156, 32); write('Echec = -10% ressources');

  // 4. Affichage de l'ASCII Art "Portrait" au centre
  couleurTexte(LightMagenta);
  deplacerCurseurXY(50, 5);  write('+++++++=++++=+++=++++=+++=++++++=++++=+++++=++++++=+++=++++=++++++=++++++=+=++=+++=++++++=++++=+++');
  deplacerCurseurXY(50, 6);  write('+++++++=++++=+++=++++=+=+=++=+++=++++=+++=++++++++=++++++=+=++=+++=*##%%###+++=+++=++++=+=++++=+++');
  deplacerCurseurXY(50, 7);  write('+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*###%%##%%##+++++++++++++++++++++');
  deplacerCurseurXY(50, 8);  write('+++  OH OH OH... Madame SOLOGNY EST LA !!!   +++++++++++++++++++#%#*++++*#%%##++++++++++++++++++++');
  deplacerCurseurXY(50, 9);  write('++=+++=++++=+=+=++=+=+=+=+==+++=+++=++=++++==++=+=+=+=++=+++=++#%#++++++**#%%#*=+=+=++++=++++++=++');
  deplacerCurseurXY(50, 10); write('++++++=+++++++++++++++=++++++++=++++++++++++++++++++++++++++++*#%*+++++***#%@%#+++++++++=+++++++++');
  deplacerCurseurXY(50, 11); write('*+=+++=++++=+=+=++=+=+=+=+==+++=+++=++=+=++=+++=+=+=+=++=+++=+#%%++**++#####@%%++=+=++++=++++++=++');
  deplacerCurseurXY(50, 12); write('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#%#+=+++**++*#@%%+++++++++++++++++++');
  deplacerCurseurXY(50, 13); write('++++++++++++=++++++=+++++=+++++++++++=++++++++=+++=++++++++++*##%**#++*##*##@%%*++=+++++++++++=+++');
  deplacerCurseurXY(50, 14); write('++++++++++++=++++++++++++=++++++++++++++++++++++++=++++++++#####%#*+++****%%%%%%*+=+++++++++++=+++');
  deplacerCurseurXY(50, 15); write('+++++=+=++++=+++=++=+=+=+=++=+=+=++++=+++=++=+=+++=+++=++=*########%#**######@%###=++=+=+=++++=+++');
  deplacerCurseurXY(50, 16); write('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*########%%%#####%@%##%#++++++++++++++++');
  deplacerCurseurXY(50, 17); write('++++++++++++=++++++=+++=+=+++++++++++++++++++++=++=+++++++#%#######%@@%%%@@@#####%%+++++++++++=+++');
  deplacerCurseurXY(50, 18); write('++++++=++++++=++++=+++=+=++++++=++++++=+=+=+=++++++=++++=*########%%@@##%#######%@#*++++=++++++=++');
  deplacerCurseurXY(50, 19); write('++++++=+++++++++++++++++++==+++=++===++++=+++++++++++++++*########%%%%##%%#####%%#%#++++=+++==+=++');
  deplacerCurseurXY(50, 20); write('++++++=++++++=++++=+++=++=++++=+=++++=+++=++++++++++++++**####%%%%%#*###%%%@@%@@#%@#*++=+=++++=+++');
  deplacerCurseurXY(50, 21); write('++++++=++++++++++++++++++=+++++++++++++++++++++++++++++***#%%%#######****##%@@@%%@%##+++++++++++++');
  deplacerCurseurXY(50, 22); write('+++++++++++++++++++++++++++++++++++++++++++++++++++++++****%###*+*####*++***%%%%@%###%++++++++++++');
  deplacerCurseurXY(50, 23); write('++++++++++++++++++++++++++++++++++++++++++++++++++++++*###****++++**#@#+++*****#%%#%%#*+++++++++++');
  deplacerCurseurXY(50, 24); write('+++=+=*=++++=+++=++=+=++=*=++++=+++=++=+=++=+=+=++=++*#******#*+++*#%@##***#######%####*=+++==+=++');
  deplacerCurseurXY(50, 25); write('++++++++++++++++++++++++++++++++++++++++++++++++++=++######*#%@%%##%@@###%%@%#%%%%@%#%%*=+++++++++');
  deplacerCurseurXY(50, 26); write('+++++=+=++++=++++++=++++=++++++=+++=++=++++=+++=++=++*%#####%%%%%###%%###%%##%@%@%@@%%@*=++++++=++');
  deplacerCurseurXY(50, 27); write('+++++++++++++++++++++++++++++++++++++++++++++++++++++++*#%%@@@%######@%%%%@@@@@@@@@@%#++++++++++++');
  deplacerCurseurXY(50, 28); write('++++++=+++++++++++=++++++=++++++++++++++++++=+++++++++++++*%%#####%%@%%%@@@@@@@@%*++++++++++++=+++');
  deplacerCurseurXY(50, 29); write('++++++=++++++=++++=++++++=+++++++++++=+++=++++++++++++++=+*###%%%%@@@######%#%@@%*=++++++++++==+++');
  deplacerCurseurXY(50, 30); write('%+++++=++++++=++++=+++=++=++++++=++++=+++=++=++++++=++++=+####%%%%#%@######%##%%%#=++++=+=++++=+++');
  SonApparitionSologny();
  // Légende
  dessinerCadreXY(60, 32, 110, 34, simple, LightMagenta, Black);
  deplacerCurseurXY(65, 33); write('MME Sologny - PROFESSEUR D''ANGLAIS');

  // 3. Dialogue d'intro
  couleurTexte(White);
  dessinerCadreXY(5, 5, 45, 15, double, White, Black);
  deplacerCurseurXY(8, 7); write('HELLO STUDENT !');
  deplacerCurseurXY(8, 9); write('Vous pensiez m''echapper');
  deplacerCurseurXY(8, 10); write('meme sur ',partie.Zones[partie.IndexZoneActive].Nom,' ?');
  deplacerCurseurXY(8, 12); write('CONTROLE SURPRISE !');
  deplacerCurseurXY(8, 13); write('Donnez-moi 3 verbes !');

  // 4. Boucle des 3 questions

  for i := 1 to 3 do
  begin
    randVerb := Random(10) + 1; // Choix d'un verbe au hasard
    
    dessinerCadreXY(5, 18, 45, 30, simple, White, Black);
    
    couleurTexte(Yellow);
    deplacerCurseurXY(8, 20); write('VERBE ', i, '/3 : ', verbes[randVerb, 1]); // Affiche l'infinitif (ex: GO)
    deplacerCurseurXY(8, 20); write('VERBE ', i, '/3 : ', verbes[randVerb, 1]); 
    
    // Demande du Prétérit
    couleurTexte(LightCyan);
    deplacerCurseurXY(8, 22); write('PRETERIT ? (Past Simple)');
    deplacerCurseurXY(8, 23); write('> ');
    readln(repPreterit);
    
    // Demande du Participe Passé
    deplacerCurseurXY(8, 25); write('PARTICIPE PASSE ?');
    deplacerCurseurXY(8, 26); write('> ');
    readln(repParticipe);

    // Vérification (On met tout en majuscules pour comparer)
    if (UpperCase(repPreterit) <> verbes[randVerb, 2]) OR 
       (UpperCase(repParticipe) <> verbes[randVerb, 3]) then
    begin
       echec := True;
       couleurTexte(LightRed);
       deplacerCurseurXY(8, 28); write('WRONG ! C''est une catastrophe.');
       attendre(1500);
       Break; // On arrête tout de suite, c'est perdu !
    end
    else
    begin
       SonMission();
       couleurTexte(LightGreen);
       deplacerCurseurXY(8, 28); write('VERY GOOD !');
       attendre(1000);
    end;
  end;

  // 5. Résultat
  // 7. Écran de Résultat
  effacerEcran();
  if echec then
  begin
    SonGameOver();
    // CAS DEFAITE : On perd 10% des ressources
     couleurTexte(LightRed);
    dessinerCadreXY(2, 1, 199, 39, double, Red, Black);
    deplacerCurseurXY(85, 18); write('ECHEC DU CONTROLE !');
    deplacerCurseurXY(80, 20); write('Mme Sologny confisque 10% de vos ressources');
    deplacerCurseurXY(80, 21); write('pour "manque de travail".');
    
    // Calcul de la pénalité 
    inv^.Bois := inv^.Bois - Round(inv^.Bois * 0.1);
    inv^.Brique := inv^.Brique - Round(inv^.Brique * 0.1);
    inv^.Cuivre := inv^.Cuivre - Round(inv^.Cuivre * 0.1);
    inv^.Titane := inv^.Titane - Round(inv^.Titane * 0.1);
    inv^.Netherite := inv^.Netherite - Round(inv^.Netherite * 0.1);
    inv^.Paladium := inv^.Paladium - Round(inv^.Paladium * 0.1);
    inv^.Endium := inv^.Endium - Round(inv^.Endium * 0.1);
    partie.DolarsZANI := partie.DolarsZANI - Round(partie.DolarsZANI * 0.1);
    
    deplacerCurseurXY(80, 23); write('(Inventaire allege...)');
  end
  else
  begin
    SonVictoireSologny();
    couleurTexte(LightGreen);
    dessinerCadreXY(2, 1, 199, 39, double, Green, Black);
    deplacerCurseurXY(85, 18); write('CONGRATULATIONS !');
    deplacerCurseurXY(80, 20); write('Vous pouvez retourner travailler.');
    deplacerCurseurXY(80, 22); write('And don''t forget your homework.');
  end;

  attendre(3000);
end;

end.