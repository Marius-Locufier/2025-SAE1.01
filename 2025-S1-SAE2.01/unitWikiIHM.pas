unit unitWikiIHM;

{$mode delphi}{$H+}

interface
  // --- AFFICHAGE DE PREMIER NIVEAU --- //
  procedure affichageFirstPage();

  // --- AFFICHAGE DE SECOND NIVEAU --- //
  procedure affichagePageBatiments();
  procedure affichagePageItems();
  procedure affichagePageZones();
  procedure affichagePageEmplacements();

  // --- AFFICHAGE DE TROISIEME NIVEAU --- //
  procedure affichagePageMines();
  procedure affichagePageUsines();
  procedure affichagePageMinerais();
  procedure affichagePageFabrics();

  // --- AFFICHAGE DE QUATRIEME NIVEAU --- //
  procedure affichagePageNiveauMine();
  procedure affichagePageRangMine();
  
implementation

uses
  SysUtils, Classes, GestionEcran, unitWiki; 

procedure affichageFirstPage();
begin
  changerTailleConsole(200,40);
  dessinerCadreXY(1,1, 199,39, simple, LightBlue, Black);
  couleurTexte(LightBlue);
  // --- CREATION DU LOGO WIKI --- //
  deplacerCurseurXY(78,5);  write(' | |    ___    | |  | |  | |  _/ /  | | ');
  deplacerCurseurXY(78,6);  write('  \ \  / _ \  / /   | |  | |_/ _/   | | ');
  deplacerCurseurXY(78,7);  write('   \ \/ / \ \/ /    | |  | |_ |_    | | ');
  deplacerCurseurXY(78,8);  write('    \  /   \  /     | |  | | \_ \   | | ');
  deplacerCurseurXY(78,9);  write('     \/     \/      | |  | |   \ \  | | ');
  deplacerCurseurXY(78,10); write('_______________________________________');
  deplacerCurseurXY(77,11); write('|________________________________________|');

  // --- AFFICHAGE DES CHOIX --- //
  dessinerCadreXY(63,15, 93,19, simple, White, Black);
  couleurTexte(LightRed);
  deplacerCurseurXY(66,17); write('[1] - WIKI DES BATIMENTS');
  ///////////////////
  dessinerCadreXY(103,15, 133,19, simple, White, Black);
  couleurTexte(LightMagenta);
  deplacerCurseurXY(108,17);write('[2] - WIKI DES ITEMS');
  ///////////////////
  dessinerCadreXY(63,22, 93,26, simple, White, Black);
  couleurTexte(Yellow);
  deplacerCurseurXY(68,24);write('[3] - WIKI DES ZONES');
  ///////////////////
  dessinerCadreXY(103,22, 133,26, simple, White, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(105,24);write('[4] - WIKI DES EMPLACEMENTS');
  ///////////////////
  couleurTexte(Red);
  deplacerCurseurXY(84,37); write('POUR REVENIR AU JEU ENTREZ [0]');

  // --- ZONE D'ENTREE DU CHOIX --- //
  dessinerCadreXY(83,30, 113,34, simple, White, Black);
  couleurTexte(LightBlue); 
  deplacerCurseurXY(85,32); write('ENTREZ VOTRE CHOIX : ');
  dessinerCadreXY(107,31, 112,33, simple, LightBlue, Black);
  deplacerCurseurXY(109,32);
  couleurTexte(White);
end;





procedure affichagePageBatiments();
begin
  // --- AFFICHAGE DES DEUX CHOIX --- //
  effacerEcran();
  ///////////////// Choix usines
  dessinerCadreXY(1,1, 97,30, double, LightRed, Black);
  couleurTexte(LightRed);
  deplacerCurseurXY(48,12);
  write('[1]');
  deplacerCurseurXY(46,15);
  write('USINES');
  ///////////////// Choix mines
  dessinerCadreXY(103,1, 199,30, double, LightCyan, Black);
  couleurTexte(LightCyan);
  deplacerCurseurXY(149,12);
  write('[2]');
  deplacerCurseurXY(148,15);
  write('MINES');
  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(84,37); write('POUR REVENIR AU JEU ENTREZ [0]');

  // --- ZONE D'ENTREE DU CHOIX --- //
  dessinerCadreXY(83,32, 113,36, simple, White, Black);
  couleurTexte(Yellow); 
  deplacerCurseurXY(85,34); write('ENTREZ VOTRE CHOIX : ');
  dessinerCadreXY(107,33, 112,35, simple, Yellow, Black);
  deplacerCurseurXY(109,34);
  couleurTexte(White);
end;





procedure affichagePageItems();
begin
  // --- AFFICHAGE DES DEUX CHOIX --- //
  effacerEcran();
  ///////////////// Choix minerais
  dessinerCadreXY(1,1, 97,30, double, LightRed, Black);
  couleurTexte(LightRed);
  deplacerCurseurXY(48,12);
  write('[1]');
  deplacerCurseurXY(45,15);
  write('MINERAIS');
  ///////////////// Choix fabric
  dessinerCadreXY(103,1, 199,30, double, Yellow, Black);
  couleurTexte(Yellow);
  deplacerCurseurXY(149,12);
  write('[2]');
  deplacerCurseurXY(141,15);
  write('COMPOSANTS FABRIQUES');
  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(84,37); write('POUR REVENIR AU JEU ENTREZ [0]');

  // --- ZONE D'ENTREE DU CHOIX --- //
  dessinerCadreXY(83,32, 113,36, simple, White, Black);
  couleurTexte(Yellow); 
  deplacerCurseurXY(85,34); write('ENTREZ VOTRE CHOIX : ');
  dessinerCadreXY(107,33, 112,35, simple, Yellow, Black);
  deplacerCurseurXY(109,34);
  couleurTexte(White);
end;




procedure affichagePageZones();
begin
  effacerEcran();

  // --- ZONE VILTRIUM --- //
  couleurTexte(Cyan);
  deplacerCurseurXY(28,5);
  write('VILTRIUM');
  dessinerCadreXY(1,12, 66,32, simple, Cyan, Black);

  deplacerCurseurXY(6,14);
  write('Viltrium est une vaste zone aride sur Mars. Le sol');
  deplacerCurseurXY(6,15);
  write('y forme des reliefs rouges aux formes abruptes. La');
  deplacerCurseurXY(6,16);
  write('lumiere y reste faible mais stable. Le vent froid');
  deplacerCurseurXY(6,17);
  write('trace des sillons dans la poussiere. Au centre se');
  deplacerCurseurXY(6,18);
  write('trouve un plateau isole qui semble garder un secret');
  deplacerCurseurXY(6,19);
  write('ancien.');

  deplacerCurseurXY(20,25); write('--- PREMIERE ZONE ---');

  // --- ZONE ARCADIA --- //
  couleurTexte(Green);
  deplacerCurseurXY(95,5);
  write('ARCADIA');
  dessinerCadreXY(67,12, 132,32, simple, Green, Black);

  deplacerCurseurXY(73,14);
  write('Arcadia est une vaste region de Mars ou le sol sombre');
  deplacerCurseurXY(73,15);
  write('s etend a perte de vue. De vieux passages de glace');
  deplacerCurseurXY(73,16);
  write('forment des arcs et des creux qui dessinent un');
  deplacerCurseurXY(73,17);
  write('labyrinthe naturel. Quelques buttes se dressent comme');
  deplacerCurseurXY(73,18);
  write('des tours perdues et projettent de longues ombres. La');
  deplacerCurseurXY(73,19);
  write('nuit, une fine poussiere semble briller faiblement et');
  deplacerCurseurXY(73,20);
  write('donne a Arcadia une atmosphere calme et presque mystique.');

  deplacerCurseurXY(86,25); write('--- SECONDE ZONE ---');

  // --- ZONE TITAN --- //
  couleurTexte(Red);
  deplacerCurseurXY(165,5);
  write('TITAN');
  dessinerCadreXY(133,12, 198,32, simple, Red, Black);

  deplacerCurseurXY(139,14);
  write('Titan est une zone rocheuse de Mars ou de grands');
  deplacerCurseurXY(139,15);
  write('plateaux sombres dominent une plaine froide. Le sol');
  deplacerCurseurXY(139,16);
  write('est marque par des failles profondes qui forment un');
  deplacerCurseurXY(139,17);
  write('reseau naturel. Parfois, une brume fine traverse la');
  deplacerCurseurXY(139,18);
  write('region et adoucit les contours. Titan semble immobile');
  deplacerCurseurXY(139,19);
  write('mais donne l impression qu une force ancienne veille');
  deplacerCurseurXY(139,20);
  write('encore sous la surface.');
  
  deplacerCurseurXY(153,25); write('--- TROISIEME ZONE ---');

  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;




procedure affichagePageEmplacements();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(89,1, 110,5, double, White, Black);
  deplacerCurseurXY(92,3);
  couleurTexte(Green);
  write('LES EMPLACEMENTS');

  // --- LES EMPLACEMENTS --- //
  dessinerCadreXY(49,8, 151,16, simple, White, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(58,11);
  write('Dans une zone du jeu, il y a dix emplacements. Ces emplacements servent a construire');
  deplacerCurseurXY(58,12);
  write('des batiments afin de produire des ressources dans ces zones.');
  deplacerCurseurXY(58,13);
  write('Cette page va detailler les differents etats de ces emplacements.');

  // --- DESCRIPTION DES EMPLACEMENTS NON-DECOUVERTS --- //
  //Création des bordures
  dessinerCadreXY(1,20, 66,22, simple, White, Black);
  dessinerCadreXY(1,22, 66,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightRed);
  //Titre
  deplacerCurseurXY(28,21);
  write('NON-DECOUVERT');
  //Texte
  deplacerCurseurXY(6,24);
  write('Un emplacement peut-etre non-decouvert, on doit donc');
  deplacerCurseurXY(6,25);
  write('aller explorer la zone avant de pouvoir construire');
  deplacerCurseurXY(6,26);
  write('des batiments dessus.');
  deplacerCurseurXY(6,27);
  write('Un emplacement est non-decouvert quand il a une');
  deplacerCurseurXY(6,28);
  write('inscription en son centre notee :');
  deplacerCurseurXY(23,30);
  write('"? ZONE NON EXPLOREE ?"');

  
  // --- DESCRIPTION DES EMPLACEMENTS VIDES --- //
  //Création des bordures
  dessinerCadreXY(67,20, 132,22, simple, White, Black);
  dessinerCadreXY(67,22, 132,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightCyan);
  //Titre
  deplacerCurseurXY(98,21);
  write('VIDE');
  //Texte
  deplacerCurseurXY(72,24);
  write('Un emplacement peut-etre vide, on peut alors');
  deplacerCurseurXY(72,25);
  write('construire des usines dessus, les differents types');
  deplacerCurseurXY(72,26);
  write('de ces usines sont detaillees dans la rubrique');
  deplacerCurseurXY(72,27);
  write('"BATIMENTS" de ce Wiki.');
  deplacerCurseurXY(72,28);
  write('On reconnait les emplacements vides par une ');
  deplacerCurseurXY(72,29);
  write('inscription :');
  deplacerCurseurXY(93,30);
  write('"TERRAIN VIDE"');


  // --- DESCRIPTION DES EMPLACEMENTS AVEC GISEMENTS --- //
  //Création des bordures
  dessinerCadreXY(133,20, 198,22, simple, White, Black);
  dessinerCadreXY(133,22, 198,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(Yellow);
  //Titre
  deplacerCurseurXY(160,21);
  write('GISEMENTS');
  //Texte
  deplacerCurseurXY(138,24);
  write('Quand on decouvre un emplacement on a une chance');
  deplacerCurseurXY(138,25);
  write('que cet emplacement soit un gisement.');
  deplacerCurseurXY(138,26);
  write('Ce gisement contient en masse un seul minerai,');
  deplacerCurseurXY(138,27);
  write('qui peut avoir differents grades de purete.');
  deplacerCurseurXY(138,28);
  write('On pourra poser une mine dessus. On reconnait un');
  deplacerCurseurXY(138,29);
  write('gisement avec : ');
  deplacerCurseurXY(155,30);
  write('"Gisement [MINERAI]"');


  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;





procedure affichagePageUsines();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(89,1, 110,5, double, White, Black);
  deplacerCurseurXY(92,3);
  couleurTexte(LightRed);
  write('LES USINES');

  // --- LES USINES --- //
  dessinerCadreXY(49,8, 151,16, simple, White, Black);
  couleurTexte(LightRed);
  deplacerCurseurXY(58,11);
  write('Dans les emplacements vides, on peut construire des usines, ces');
  deplacerCurseurXY(58,12);
  write('usines servent a fabriquer des ressources.Cette page va detailler');
  deplacerCurseurXY(58,13);
  write('les differentes usines que nous pouvons trouver dans le jeu.');

  // --- CARRIERE --- //
  //Création des bordures
  dessinerCadreXY(1,20, 40,22, simple, White, Black);
  dessinerCadreXY(1,22, 40,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(Yellow);
  //Titre
  deplacerCurseurXY(16,21);
  write('CARRIERE');
  //Texte
  deplacerCurseurXY(3,24);  write('La carriere est un des nombreux  ');
  deplacerCurseurXY(3,25);  write('batiments que nous pouvons con-  ');
  deplacerCurseurXY(3,26);  write('struire dans le jeu.             ');
  deplacerCurseurXY(3,27);  write('La carriere permet de gagner des ');
  deplacerCurseurXY(3,28);  write('briques.                         ');

  // --- FORET --- //
  //Création des bordures
  dessinerCadreXY(41,20, 80,22, simple, White, Black);
  dessinerCadreXY(41,22, 80,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightGreen);
  //Titre
  deplacerCurseurXY(57,21);
  write('FORET');
  //Texte
  deplacerCurseurXY(43,24); write('La foret est un des nombreux     ');
  deplacerCurseurXY(43,25); write('batiments que nous pouvons con-  ');
  deplacerCurseurXY(43,26); write('struire dans le jeu.             ');
  deplacerCurseurXY(43,27); write('La foret permet de gagner du     ');
  deplacerCurseurXY(43,28); write('bois.                            ');

  // --- CABLES --- //
  //Création des bordures
  dessinerCadreXY(81,20, 120,22, simple, White, Black);
  dessinerCadreXY(81,22, 120,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightBlue);
  //Titre
  deplacerCurseurXY(92,21);
  write('USINE DE CABLES');
  //Texte
  deplacerCurseurXY(83,24); write('Une usine de cables est un des   ');
  deplacerCurseurXY(83,25); write('nombreux batiments que nous      ');
  deplacerCurseurXY(83,26); write('pouvons construire dans le jeu.  ');
  deplacerCurseurXY(83,27); write('Elle permet de gagner des cables.');

  // --- BLOCS --- //
  //Création des bordures
  dessinerCadreXY(121,20, 160,22, simple, White, Black);
  dessinerCadreXY(121,22, 160,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightMagenta);
  //Titre
  deplacerCurseurXY(133,21);
  write('USINE DE BLOCS');
  //Texte
  deplacerCurseurXY(123,24); write('Une usine de blocs est un des    ');
  deplacerCurseurXY(123,25); write('nombreux batiments que nous      ');
  deplacerCurseurXY(123,26); write('pouvons construire dans le jeu.  ');
  deplacerCurseurXY(123,27); write('Elle permet de gagner des blocs. ');

  // --- PC --- //
  //Création des bordures
  dessinerCadreXY(161,20, 199,22, simple, White, Black);
  dessinerCadreXY(161,22, 199,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightCyan);
  //Titre
  deplacerCurseurXY(174,21);
  write('USINE DE PC');
  //Texte
  deplacerCurseurXY(163,24); write('Une usine de PCs est un des      ');
  deplacerCurseurXY(163,25); write('nombreux batiments que nous      ');
  deplacerCurseurXY(163,26); write('pouvons construire dans le jeu.  ');
  deplacerCurseurXY(163,27); write('Elle permet de gagner des PC.    ');


  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;





procedure affichagePageMines();
begin
  // --- AFFICHAGE DES CHOIX --- //
  effacerEcran();
  ///////////////// Choix niveaux
  dessinerCadreXY(1,5, 99,25, double, LightGreen, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(47,13);
  write('[1]');
  deplacerCurseurXY(43,16);
  write('LES NIVEAUX');
  //////////////// Choix pureté
  dessinerCadreXY(101,5, 199,25, double, LightCyan, Black);
  couleurTexte(LightCyan);
  deplacerCurseurXY(147,13);
  write('[2]');
  deplacerCurseurXY(138,16);
  write('LES RANGS DE PURETE');
  ///////////////// choix retour
  couleurTexte(Red);
  deplacerCurseurXY(84,37); write('POUR REVENIR AU JEU ENTREZ [0]');

  // --- ZONE D'ENTREE DU CHOIX --- //
  dessinerCadreXY(83,32, 113,36, simple, White, Black);
  couleurTexte(Yellow); 
  deplacerCurseurXY(85,34); write('ENTREZ VOTRE CHOIX : ');
  dessinerCadreXY(107,33, 112,35, simple, Yellow, Black);
  deplacerCurseurXY(109,34);
  couleurTexte(White);
end;



procedure affichagePageMinerais();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(85,1, 115,5, double, White, Black);
  deplacerCurseurXY(93,3);
  couleurTexte(Brown);
  write('LES MINERAIS');

  // --- LES MINERAIS --- //
  dessinerCadreXY(49,8, 151,13, simple, White, Black);
  couleurTexte(Brown);
  deplacerCurseurXY(58,10); write('Les mines, presentees dans la premiere partie, vont nous permettre de trouver des');
  deplacerCurseurXY(58,11); write('minerais. Ce sont ces minerais dont nous allons faire la description ici.        ');

  // --- CUIVRE --- //
  //Création des bordures
  dessinerCadreXY(1,20, 40,22, simple, White, Black);
  dessinerCadreXY(1,22, 40,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(Yellow);
  //Titre
  deplacerCurseurXY(17,21);
  write('CUIVRE');
  //Texte
  deplacerCurseurXY(4,24);  write('Le Cuivre est un des 5 minerais  ');
  deplacerCurseurXY(4,25);  write('de la planete Mars, il est aussi ');
  deplacerCurseurXY(4,26);  write('le plus courant. On le trouve    ');
  deplacerCurseurXY(4,27);  write('dans les mines construites sur un');
  deplacerCurseurXY(4,28);  write('gisement de cuivre.              ');

  // --- TITANE --- //
  //Création des bordures
  dessinerCadreXY(41,20, 80,22, simple, White, Black);
  dessinerCadreXY(41,22, 80,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightMagenta);
  //Titre
  deplacerCurseurXY(57,21);
  write('TITANE');
  //Texte
  deplacerCurseurXY(44,24); write('Le Titane est un des 5 minerais  ');
  deplacerCurseurXY(44,25); write('de Mars, il est aussi le deuxième');
  deplacerCurseurXY(44,26); write('plus commun des 5. On le trouve  ');
  deplacerCurseurXY(44,27); write('dans les mines crees sur les     ');
  deplacerCurseurXY(44,28); write('gisements de Titane.             ');

  // --- NETHERITE --- //
  //Création des bordures
  dessinerCadreXY(81,20, 120,22, simple, White, Black);
  dessinerCadreXY(81,22, 120,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightBlue);
  //Titre
  deplacerCurseurXY(95,21);
  write('NETHERITE');
  //Texte
  deplacerCurseurXY(84,24); write('La Netherite est le minerai au   ');
  deplacerCurseurXY(84,25); write('milieu de la hierarchie des      ');
  deplacerCurseurXY(84,26); write('minerais de Mars. On le trouve   ');
  deplacerCurseurXY(84,27); write('dans les mines de Netherite.     ');

  // --- PALLADIUM --- //
  //Création des bordures
  dessinerCadreXY(121,20, 160,22, simple, White, Black);
  dessinerCadreXY(121,22, 160,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightGreen);
  //Titre
  deplacerCurseurXY(137,21);
  write('PALLADIUM');
  //Texte
  deplacerCurseurXY(124,24); write('Le Palladium est un minerai très ');
  deplacerCurseurXY(124,25); write('rare sur Mars.                   ');
  deplacerCurseurXY(124,26); write('On le trouve dans les mines de   ');
  deplacerCurseurXY(124,27); write('Palladium.                       ');

  // --- ENDIUM --- //
  //Création des bordures
  dessinerCadreXY(161,20, 199,22, simple, White, Black);
  dessinerCadreXY(161,22, 199,32, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightCyan);
  //Titre
  deplacerCurseurXY(176,21);
  write('ENDIUM');
  //Texte
  deplacerCurseurXY(164,24); write('L Endium est le minerai le plus  ');
  deplacerCurseurXY(164,25); write('rare de Mars. Tellement rare que ');
  deplacerCurseurXY(164,26); write('vous pouvez considerer comme une ');
  deplacerCurseurXY(164,27); write('chance de trouver un gisement.   ');


  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;




procedure affichagePageFabrics();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(85,1, 115,5, double, White, Black);
  deplacerCurseurXY(90,3);
  couleurTexte(LightGray);
  write('LES OBJETS ARTIFICIELS');

  // --- LES FABRICS --- //
  dessinerCadreXY(49,8, 151,13, simple, White, Black);
  couleurTexte(LightGray);
  deplacerCurseurXY(58,10); write('Les usines, presentees dans la premiere partie, vont nous permettre de creer des');
  deplacerCurseurXY(58,11); write('objets. Ce sont ces objets dont nous allons faire la description ici.           ');

  // --- LE BOIS --- //
  //Création des bordures
  dessinerCadreXY(1,15, 66,17, simple, White, Black);
  dessinerCadreXY(1,17, 66,24, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightRed);
  //Titre
  deplacerCurseurXY(29,16);
  write('LE BOIS');
  //Texte
  deplacerCurseurXY(3,19); write('Le bois est une des ressources principales de notre jeu,   ');
  deplacerCurseurXY(3,20); write('on le trouve dans les forets artificielles construites par ');
  deplacerCurseurXY(3,21); write('les etudiants quand ils sont arrives. Il permet la cons-   ');
  deplacerCurseurXY(3,22); write('truction de nombreux batiments tel que les usines de blocs.');


  // --- LA BRIQUE --- //
  //Création des bordures
  dessinerCadreXY(67,15, 132,17, simple, White, Black);
  dessinerCadreXY(67,17, 132,24, simple, White, Black);
  //Set de la couleur
  couleurTexte(Yellow);
  //Titre
  deplacerCurseurXY(94,16);
  write('LA BRIQUE');
  //Texte
  deplacerCurseurXY(69,19); write('La brique est un des objets principaux de notre jeu, on la ');
  deplacerCurseurXY(69,20); write('cree dans les carrieres construites par les etudiants quand');
  deplacerCurseurXY(69,21); write('ils sont arrives. Elle permet la construction de nombreux  ');
  deplacerCurseurXY(69,22); write('batiments.'                                                 );


  // --- LES CABLES ELEC --- //
  //Création des bordures
  dessinerCadreXY(133,15, 198,17, simple, White, Black);
  dessinerCadreXY(133,17, 198,24, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightGreen);
  //Titre
  deplacerCurseurXY(155,16);
  write('LES CABLES ELECTRIQUES');
  //Texte
  deplacerCurseurXY(135,19); write('Les cables electriques sont une ressource creee pour       ');
  deplacerCurseurXY(135,20); write('transporter l energie et pour construire des batiments tels');
  deplacerCurseurXY(135,21); write('que la centrale electrique ou l ascenseur orbital. On les  ');
  deplacerCurseurXY(135,22); write('cree dans les usines a cables.');


  // --- BLOCS DE CONSTRUCTIONS --- //
  //Création des bordures
  dessinerCadreXY(1,26, 66,28, simple, White, Black);
  dessinerCadreXY(1,28, 66,35, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightCyan);
  //Titre
  deplacerCurseurXY(23,27);
  write('BLOCS DE CONSTRUCTIONS');
  //Texte
  deplacerCurseurXY(3,30); write('Les blocs de constructions sont primordiaux quand il y a   ');
  deplacerCurseurXY(3,31); write('besoin de creer un gros batiment.                          ');
  deplacerCurseurXY(3,32); write('On les produit dans une usine a blocs de constructions.    ');


  // --- PC GAMERS --- //
  //Création des bordures
  dessinerCadreXY(67,26, 132,28, simple, White, Black);
  dessinerCadreXY(67,28, 132,35, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightBlue);
  //Titre
  deplacerCurseurXY(94,27);
  write('LES PC-GAMERS');
  //Texte
  deplacerCurseurXY(69,30); write('Les PC-GAMERS sont un des objectifs de cette exploitation  ');
  deplacerCurseurXY(69,31); write('de Mars, ils sont envoyes sur Terre contre des DollarZanis ');
  deplacerCurseurXY(69,32); write('pendant des missions donnees grace a l ascenseur orbital.  ');
  deplacerCurseurXY(69,33); write('On les cree grace a une usine de PC-GAMERS.                ');


  // --- ENERGIE --- //
  //Création des bordures
  dessinerCadreXY(133,26, 198,28, simple, White, Black);
  dessinerCadreXY(133,28, 198,35, simple, White, Black);
  //Set de la couleur
  couleurTexte(LightMagenta);
  //Titre
  deplacerCurseurXY(162,27);
  write('ENERGIE');
  //Texte
  deplacerCurseurXY(136,30); write('L energie est une ressource produite a partir des centrales');
  deplacerCurseurXY(136,31); write('electriques. Elle nous permettra de faire marcher un       ');
  deplacerCurseurXY(136,32); write('ascenseur orbital, elle est donc une ressource primordiale ');
  deplacerCurseurXY(136,33); write('pour la survie sur Mars.                                   ');

  
  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;




procedure affichagePageNiveauMine();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(85,1, 115,5, double, White, Black);
  deplacerCurseurXY(95,3);
  couleurTexte(LightCyan);
  write('LES NIVEAUX');

  // --- LES NIVEAUX DE MINES --- //
  dessinerCadreXY(49,8, 151,28, simple, White, Black);
  couleurTexte(Yellow);
  deplacerCurseurXY(58,10); write('Les mines permettent, comme les usines, de produire des materiaux. On peut, tout');
  deplacerCurseurXY(58,11); write('comme les usines, les ameliorer. Il y a trois niveaux pour chacun des batiments.');
  deplacerCurseurXY(58,13); write('Niveau 1 : Le niveau le plus bas, chacun des batiments est niveau 1 quand on le ');
  deplacerCurseurXY(58,14); write('construit.');
  deplacerCurseurXY(58,16); write('Niveau 2 : Le niveau moyen.');
  deplacerCurseurXY(58,18); write('Niveau 3 : Le niveau final.');
  deplacerCurseurXY(58,22); write('Pour ameliorer un batiment, le cout depend du niveau : ');
  deplacerCurseurXY(58,24); write('Du niv.1 au niv.2, le cout est de 1000 DollarZanis.');
  deplacerCurseurXY(58,26); write('Du niv.2 au niv.3, le cout est de 2000 DollarZanis.');

  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;



procedure affichagePageRangMine();
begin
  effacerEcran();

  // --- TITRE --- //
  dessinerCadreXY(85,1, 115,5, double, White, Black);
  deplacerCurseurXY(95,3);
  couleurTexte(Green);
  write('LES NIVEAUX');

  // --- LES RANGS DE MINES --- //
  dessinerCadreXY(49,8, 151,26, simple, White, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(58,10); write('Les mines permettent, comme les usines, de produire des materiaux. La difference');
  deplacerCurseurXY(58,11); write('est que les mines possèdent un niveau de pureté du gisement, qui influera sur la');
  deplacerCurseurXY(58,13); write('production de la mine : ');
  deplacerCurseurXY(58,15); write('[C] : Le rang le plus faible, il y a une très grosse probabilite de le tirer.   ');
  deplacerCurseurXY(58,17); write('[B] : Ce rang est plus rare que le C, et plus rentable.');
  deplacerCurseurXY(58,19); write('[A] : Le rang A est un rang rare a obtenir, il est tres rentable.');
  deplacerCurseurXY(58,21); write('[S] : Le rang S est le rang legendaire.');
  deplacerCurseurXY(58,24); write('On peut améliorer le niveau de la mine, mais pas son rang de purete.');

  ///////////////// Choix retour
  couleurTexte(Red);
  deplacerCurseurXY(81,37); write('POUR REVENIR AU JEU TAPEZ SUR [ENTER]');
end;

end.