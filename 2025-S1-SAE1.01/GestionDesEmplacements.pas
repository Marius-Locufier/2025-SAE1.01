unit GestionDesEmplacements;

{$mode delphi}

interface

uses
  SysUtils, GestionEcran, unitEmplacementConstruction, unitIHM, unitlogic, unitBatiment,Musique_bonus;

const
  // Nombre maximum d'emplacements constructibles dans une zone
  MAX_EMPLACEMENTS = 10;
  
  //CODES POUR L'ETAT DU SOL 
  SOL_INCONNU   = 0; // Case noire, on ne sait pas ce qu'il y a
  SOL_VIDE      = 1; // Case explorée, mais il n'y a rien 
  SOL_HUB       = 99; // Case spéciale réservée au Hub 
  
  // CODES POUR LES RESSOURCES
  //indiquent quel minerai se trouve dans le sol une fois découvert
  RES_CUIVRE    = 2;
  RES_TITANE    = 3;
  RES_NETHERITE = 4;
  RES_PALLADIUM = 5;
  RES_Endium    = 6;

  //CODES POUR LA PURETE
  //Détermine la richesse du gisement 
  RANG_NUL = 0;
  RANG_C   = 1; 
  RANG_B   = 2; 
  RANG_A   = 3; 
  RANG_S   = 4; 

  //BATIMENTS
  BAT_AUCUN       = 0; // Pas de construction sur cette case
  BAT_MINE        = 1; // Mine (se construit sur un gisement)
  
  // Usines (se construisent sur un terrain vide)
  BAT_CARRIERE    = 2; 
  BAT_FORET       = 3;
  BAT_USINE_CABLE = 4;
  BAT_USINE_BLOCK = 5;
  BAT_USINE_PC    = 6;
  
  // Production d'énergie
  BAT_CENTRALE    = 7;

type
  // Type tableau utilisé pour stocker les données de la carte
  TTableauInt = array[1..MAX_EMPLACEMENTS] of Integer;

var
  //VARIABLES GLOBALES DE L'UNITÉ
  TerrainMemoire   : TTableauInt; // Ce qu'il y a dans le sol 
  PureteMemoire    : TTableauInt; // La qualité du sol (Rang)
  BatimentsMemoire : TTableauInt; // Ce qu'on a construit dessus
  NiveauBatiments  : TTableauInt; // Le niveau d'amélioration 
  PanneMemoire     : TTableauInt; // État de panne 

// Procédures 
procedure LancerModeExploration();
procedure AfficherSideBarComplet(); 
procedure SauvegarderZone(idZone : Integer);
procedure ChargerZone(idZone : Integer);

implementation

procedure SauvegarderZone(idZone : Integer);
var i: Integer;
begin
  for i := 1 to MAX_EMPLACEMENTS do
  begin
    partie.Zones[idZone].Emplacements[i].GisementType := TerrainMemoire[i];
    partie.Zones[idZone].Emplacements[i].Purete       := PureteMemoire[i];
    partie.Zones[idZone].Emplacements[i].BatimentType := BatimentsMemoire[i];
    partie.Zones[idZone].Emplacements[i].Niveau       := NiveauBatiments[i];

    // Si on connait le terrain, on note que la case est découverte
    if TerrainMemoire[i] <> SOL_INCONNU then
       partie.Zones[idZone].Emplacements[i].EstDecouvert := True
    else
       partie.Zones[idZone].Emplacements[i].EstDecouvert := False;
    if PanneMemoire[i] = 1 then 
       partie.Zones[idZone].Emplacements[i].EnPanne := True
    else 
       partie.Zones[idZone].Emplacements[i].EnPanne := False;
  end;
end;

// Récupère les infos de la zone (depuis la mémoire) pour pouvoir jouer dessus
procedure ChargerZone(idZone : Integer);
var i: Integer;
begin
  for i := 1 to MAX_EMPLACEMENTS do
  begin
    TerrainMemoire[i]   := partie.Zones[idZone].Emplacements[i].GisementType;
    PureteMemoire[i]    := partie.Zones[idZone].Emplacements[i].Purete;
    BatimentsMemoire[i] := partie.Zones[idZone].Emplacements[i].BatimentType;
    NiveauBatiments[i]  := partie.Zones[idZone].Emplacements[i].Niveau;
    if partie.Zones[idZone].Emplacements[i].EnPanne then 
       PanneMemoire[i] := 1
    else 
       PanneMemoire[i] := 0;
  end;
end;

// -------------------------------------------------------------------------
// FONCTIONS UTILITAIRES 
// -------------------------------------------------------------------------

// Tire au sort un type de minerai selon des probabilités définies
// Utilisé lors de la découverte d'une case 
function DeterminerTypeMinerai(): Integer;
var tirage : Integer;
begin
  tirage := Random(100) + 1; 
  if tirage <= 60 then Result := RES_CUIVRE        // 60% de chance
  else if tirage <= 85 then Result := RES_TITANE        // 25% de chance
  else if tirage <= 95 then Result := RES_NETHERITE     // 10% de chance
  else if tirage <= 99 then Result := RES_PALLADIUM     // 4% de chance
  else Result := RES_Endium;                            // 1% de chance (Rare !)
end;

// Tire au sort la pureté du gisement
// Plus le rang est élevé, plus la mine produira de ressources
function DeterminerPurete(): Integer;
var tirage : Integer;
begin
  tirage := Random(100) + 1;
  if tirage <= 50 then Result := RANG_C else if tirage <= 80 then Result := RANG_B
  else if tirage <= 95 then Result := RANG_A else Result := RANG_S;
end;

// Vérifie s'il reste des cases à découvrir dans la zone actuelle
// Renvoie True s'il y a encore des SOL_INCONNU
function ResteDesInconnus(leTerrain : TTableauInt): Boolean;
var i : Integer;
begin
  Result := False;
  for i := 1 to MAX_EMPLACEMENTS do
    if leTerrain[i] = SOL_INCONNU then begin Result := True; Exit; end;
end;

// Convertit le code décimzle du rang en texte affichable 
function GetTexteRang(rang : Integer): String;
begin
  case rang of
    RANG_C : Result := ' [C]'; 
    RANG_B : Result := ' [B]';
    RANG_A : Result := ' [A]'; 
    RANG_S : Result := ' [S]';
    else Result := '';
  end;
end;

// -------------------------------------------------------------------------
// AFFICHAGE SIDEBAR 
// -------------------------------------------------------------------------

// Affiche toute la colonne de droite : Inventaire complet + Liste des commandes
procedure AfficherSideBarComplet();
var 
  idZone, xTxt, xVal : Integer;
begin
  idZone := partie.IndexZoneActive;
  
  // Cadre global
  dessinerCadreXY(156, 1, 199, 39, double, LightCyan, Black);
  
  // Titre inventaire
  couleurTexte(Yellow);
  dessinerCadreXY(158, 2, 197, 4, simple, LightCyan, Black);
  deplacerCurseurXY(160, 3); 
  write('INV : ', partie.Zones[idZone].Nom); 

  xTxt := 160; xVal := 185; 
  couleurTexte(White);
  
  // Affichage des ressources brutes
  deplacerCurseurXY(xTxt, 6);  write('Bois      :'); deplacerCurseurXY(xVal, 6);  write(partie.Zones[idZone].Inventaire.Bois);
  deplacerCurseurXY(xTxt, 7);  write('Brique    :'); deplacerCurseurXY(xVal, 7);  write(partie.Zones[idZone].Inventaire.Brique);
  deplacerCurseurXY(xTxt, 8);  write('Cuivre    :'); deplacerCurseurXY(xVal, 8);  write(partie.Zones[idZone].Inventaire.Cuivre);
  deplacerCurseurXY(xTxt, 9);  write('Netherite :'); deplacerCurseurXY(xVal, 9);  write(partie.Zones[idZone].Inventaire.Netherite);
  deplacerCurseurXY(xTxt, 10); write('Titane    :'); deplacerCurseurXY(xVal, 10); write(partie.Zones[idZone].Inventaire.Titane);
  deplacerCurseurXY(xTxt, 11); write('Palladium :'); deplacerCurseurXY(xVal, 11); write(partie.Zones[idZone].Inventaire.Paladium);
  deplacerCurseurXY(xTxt, 12); write('Endium    :'); deplacerCurseurXY(xVal, 12); write(partie.Zones[idZone].Inventaire.Endium);
  
  // Séparateur
  deplacerCurseurXY(xTxt, 13); write('-----------------------------------');
  
  // Affichage des ressources manufacturées
  deplacerCurseurXY(xTxt, 14); write('Cables    :'); deplacerCurseurXY(xVal, 14); write(partie.Zones[idZone].Inventaire.CableElec);
  deplacerCurseurXY(xTxt, 15); write('Blocs     :'); deplacerCurseurXY(xVal, 15); write(partie.Zones[idZone].Inventaire.BlockConst);
  deplacerCurseurXY(xTxt, 16); write('PC Gamer  :'); deplacerCurseurXY(xVal, 16); write(partie.Zones[idZone].Inventaire.PCGamer);
  
  deplacerCurseurXY(xTxt, 17); write('-----------------------------------');
  
  // Energie et Argent
  couleurTexte(LightGreen);
  deplacerCurseurXY(xTxt, 18); write('Energie   :'); deplacerCurseurXY(xVal, 18); write(partie.Energie);
  couleurTexte(Yellow);
  deplacerCurseurXY(xTxt, 19); write('DolarsZANI   :'); deplacerCurseurXY(xVal, 19); write(partie.DolarsZANI);
  
  // Liste des Commandes disponibles
  couleurTexte(LightMagenta);
  dessinerCadreXY(158, 21, 197, 23, simple, LightMagenta, Black);
  deplacerCurseurXY(168, 22); write('COMMANDES');
  couleurTexte(White);
  deplacerCurseurXY(xTxt, 24); write('[1] SCANNER ZONE');
  deplacerCurseurXY(xTxt, 25); write('[2] CONSTRUIRE CENTRALE');
  deplacerCurseurXY(xTxt, 26); write('[3] CONSTRUIRE MINE');
  deplacerCurseurXY(xTxt, 27); write('[4] CONSTRUIRE USINE');
  deplacerCurseurXY(xTxt, 28); write('[5] SELECTION CASE');
  deplacerCurseurXY(xTxt, 29); write('[6] VENDRE RESSOURCES'); 
  deplacerCurseurXY(xTxt, 30); write('[7] AMELIORER BATIMENT');
  deplacerCurseurXY(xTxt, 31); write('[8] MODIFIER USINE');
  deplacerCurseurXY(xTxt, 32); write('[9] ASCENSEUR ORBITAL');
  couleurTexte(LightRed);
  deplacerCurseurXY(xTxt, 34); write('[0] RETOUR MENU');
end;

// -------------------------------------------------------------------------
// AFFICHAGE PRINCIPAL 
// -------------------------------------------------------------------------

// Rafraîchit l'écran principal : affiche les 10 cases, les bâtiments et l'état du terrain
procedure RafraichirExploration(positionCurseur : Integer; messageInfo : String);
var
  i, x, y : Integer;
  texteEtat, txtNiveau, strRang : String;
  couleurCadre, couleurTxt : Byte;
begin
  changerTailleConsole(200, 40);
  effacerEcran;
  
  // Affichage de la colonne de droite
  AfficherSideBarComplet();
  
  // Cadre de la zone de jeu
  dessinerCadreXY(2, 1, 155, 39, double, LightCyan, Black);
  dessinerCadreXY(50, 2, 105, 4, simple, LightCyan, Black);
  couleurTexte(Yellow);
  deplacerCurseurXY(55, 3); write('ZONE ACTIVE : ', partie.Zones[partie.IndexZoneActive].Nom);

  // Boucle pour dessiner chaque emplacement (1 à 10)
  for i := 1 to MAX_EMPLACEMENTS do
  begin
    // Calcul de la position des 2 colonnes
    if i <= 5 then x := 15 else x := 85;
    y := 6 + ((i - 1) mod 5) * 6;
    
    // Récupération des infos textuelles
    strRang := GetTexteRang(PureteMemoire[i]);
    if NiveauBatiments[i] > 0 then 
        txtNiveau := ' [Lv ' + IntToStr(NiveauBatiments[i]) + ']' 
    else 
        txtNiveau := '';

    // LOGIQUE D'AFFICHAGE 
    // Si un Bâtiment est présent
    if BatimentsMemoire[i] <> BAT_AUCUN then
    begin
        couleurCadre := LightCyan; couleurTxt := LightCyan;
        case BatimentsMemoire[i] of
          BAT_MINE : texteEtat := 'MINE' + strRang + txtNiveau;
          BAT_CARRIERE    : begin texteEtat := 'CARRIERE (Brique)' + txtNiveau; couleurCadre := LightRed; end;
          BAT_FORET       : begin texteEtat := 'FORET (Bois)' + txtNiveau;      couleurCadre := LightGreen; end;
          BAT_USINE_CABLE : texteEtat := 'USINE CABLE' + txtNiveau;
          BAT_USINE_BLOCK : texteEtat := 'USINE BLOC' + txtNiveau;
          BAT_USINE_PC    : begin texteEtat := 'USINE PC' + txtNiveau;    couleurCadre := LightMagenta; end;
          BAT_CENTRALE    : begin texteEtat := 'CENTRALE ELEC.' + txtNiveau;    couleurCadre := Yellow; end;
          else texteEtat := 'BATIMENT INCONNU';
        end;
        // Si le bâtiment est en panne
        if PanneMemoire[i] = 1 then
        begin
          couleurCadre := Red; couleurTxt := Red; texteEtat := texteEtat + ' (PANNE)';
        end;
    end
    // Si c'est le Hub
    else if TerrainMemoire[i] = SOL_HUB then
    begin
      couleurCadre := White; couleurTxt := White; texteEtat := 'HUB CENTRAL (Base Principale)';
    end
    // Si terrain inconnu
    else if TerrainMemoire[i] = SOL_INCONNU then
    begin
      couleurCadre := DarkGray; couleurTxt := LightGray; texteEtat := '? ZONE NON EXPLOREE ?';
    end
    // Si terrain vide
    else if TerrainMemoire[i] = SOL_VIDE then
    begin
      couleurCadre := Black; couleurTxt := DarkGray; texteEtat := 'TERRAIN VIDE';
    end
    // Si c'est un gisement non exploité
    else
    begin
      case TerrainMemoire[i] of
        RES_CUIVRE    : begin couleurCadre := Brown;       
        texteEtat := 'Gisement CUIVRE' + strRang; end;

        RES_TITANE    : begin couleurCadre := LightBlue;   
        texteEtat := 'Gisement TITANE' + strRang; end;

        RES_NETHERITE : begin couleurCadre := LightRed;    
        texteEtat := 'Gisement NETHERITE' + strRang; end;
        
        RES_PALLADIUM : begin couleurCadre := LightMagenta;texteEtat := 'Gisement PALLADIUM' + strRang; end;
        RES_Endium    : begin couleurCadre := LightGreen;  texteEtat := 'Gisement ENDIUM' + strRang; end;
      end;
      if PureteMemoire[i] = RANG_S then couleurTxt := Yellow else couleurTxt := couleurCadre;
    end;

    // Dessin du cadre de l'emplacement
    if TerrainMemoire[i] = SOL_VIDE then
        dessinerCadreXY(x, y, x + 55, y + 4, simple, DarkGray, Black)
    else
        dessinerCadreXY(x, y, x + 55, y + 4, simple, couleurCadre, Black);

    if i = positionCurseur then 
       dessinerCadreXY(x - 2, y - 1, x + 57, y + 5, double, White, Black);

    // Ecriture des textes
    couleurTexte(couleurTxt);
    deplacerCurseurXY(x + 2, y + 2); write(texteEtat);
    couleurTexte(White);
    deplacerCurseurXY(x + 50, y + 1); write('#', i);
  end;

  // Affichage du message d'info en bas
  if messageInfo <> '' then
  begin
    dessinerCadreXY(37, 35, 117, 37, double, Yellow, Black);
    deplacerCurseurXY(40, 36); write('INFO > ' + messageInfo);
  end;
end;



// -------------------------------------------------------------------------
// BOUCLE PRINCIPALE 
// -------------------------------------------------------------------------


procedure LancerModeExploration();
var
  position, choix, tirageChance, nouvellePosition : Integer;
  messageResultat : String;
  actionFaite : Boolean;
begin
  ChargerZone(partie.IndexZoneActive);
  position := 1; 
  messageResultat := 'Exploration en cours...';

  repeat
    // 1. VERIFICATION FATIGUE
    if partie.Heure >= 22 then
    begin
      effacerEcran();
      dessinerCadreXY(60, 15, 140, 25, double, Red, Black);
      couleurTexte(LightRed);
      deplacerCurseurXY(70, 19); writeln('IL EST TROP TARD (22H00+). VOUS ETES EPUISE.');
      deplacerCurseurXY(75, 21); writeln('Retour force a la base...');
      attendre(2000);
      Break;
    end;

    RafraichirExploration(position, messageResultat);
    
    // --- MENU VISUEL AJOUTE ---
    dessinerCadreXY(158, 35, 197, 37, simple, LightCyan, Black);
    
    // Option de réparation affichée
    couleurTexte(White);
    deplacerCurseurXY(160, 33); write('[10] REPARER (100$)'); 
    
    couleurTexte(LightCyan);
    deplacerCurseurXY(160, 36); write('VOTRE CHOIX > '); 
    try readln(choix); except choix := 0; end;

    actionFaite := False; 

    // --- ANALYSE DU CHOIX ---
    
    if choix = 1 then // SCANNER
    begin
      SonSonar();
      if ResteDesInconnus(TerrainMemoire) then
      begin
        repeat position := Random(MAX_EMPLACEMENTS) + 1; until TerrainMemoire[position] = SOL_INCONNU;
        tirageChance := Random(100); 
        if tirageChance < 50 then 
        begin
           TerrainMemoire[position] := DeterminerTypeMinerai(); 
           PureteMemoire[position] := DeterminerPurete();
           messageResultat := 'Ressource trouvee !';
        end 
        else 
        begin
           TerrainMemoire[position] := SOL_VIDE; 
           PureteMemoire[position] := RANG_NUL;
           messageResultat := 'Zone vide.';
        end;
      end else messageResultat := 'Zone verifiee : Rien de nouveau.';
      
      actionFaite := True; 
    end
    
    else if choix = 2 then 
    begin 
        unitBatiment.ConstruireCentrale(position, messageResultat); 
        if BatimentsMemoire[position] = BAT_CENTRALE then actionFaite := True; 
    end
    
    else if choix = 3 then 
    begin 
        unitBatiment.ConstruireMine(position, messageResultat); 
        if BatimentsMemoire[position] = BAT_MINE then actionFaite := True; 
    end
    
    else if choix = 4 then 
    begin 
        unitBatiment.ConstruireUsine(position, messageResultat); 
        if BatimentsMemoire[position] <> BAT_AUCUN then actionFaite := True; 
    end
    
    // 5. SELECTION (Déplacement gratuit)
    else if choix = 5 then
    begin
      deplacerCurseurXY(160, 36); write('                  '); deplacerCurseurXY(160, 36); write('CASE (1-10) > ');
      try readln(nouvellePosition); if (nouvellePosition >= 1) and (nouvellePosition <= 10) then position := nouvellePosition; except end;
    end
    
    // 6. VENTE (Gratuit)
    else if choix = 6 then unitBatiment.MenuVente(messageResultat)

    // 7. AMELIORER
    else if choix = 7 then begin unitBatiment.AmeliorerBatiment(position, messageResultat); actionFaite := True; end
    
    // 8. MODIFIER
    else if choix = 8 then begin unitBatiment.ModifierUsine(position, messageResultat); actionFaite := True; end
    
    // 9. ASCENSEUR
    else if choix = 9 then unitEmplacementConstruction.GererEmplacementConstruction()
    
    // --- 10. REPARER (NOUVEAU) ---
    else if choix = 10 then
    begin
       if BatimentsMemoire[position] <> BAT_AUCUN then
       begin
         if PanneMemoire[position] = 1 then
         begin
            unitBatiment.ReparerBatiment(position, messageResultat);
            actionFaite := True; // Réparer prend du temps !
         end
         else messageResultat := 'Ce batiment fonctionne bien.';
       end
       else messageResultat := 'Aucun batiment a reparer ici.';
    end;

    // --- GESTION TEMPS, PANNES ET SOLOGNY ---
    if actionFaite then
    begin
      partie.Heure := partie.Heure + 2; 
      unitIHM.RencontreMadameSologny(); 
      GenererPannesAleatoires();
    end;

    SauvegarderZone(partie.IndexZoneActive);

  until choix = 0; 
end;


initialization
  Randomize;
end.