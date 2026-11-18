unit unitLogic;
{Le rôle de cette unit est de gerer les informations initale du jeu, c'est un peu le cerveau de notre jeu, on retrouve la partie action tout en bas et la partie "visuelle" bien avant
durant cette uniut on a découvert le += dont je pensais pas possible en pascal mais également la découverte de var dans les parametres.
Sans oublier d'apres moi la gestion d'erreur en pascal avec try execpt. }
{$mode delphi}{$H+}


{d'ailleurs pour hugo,marius,antoine je viens de découvrir le "beep" avec le uses windows qui permet de jouer un petit beep du style beep(1000,200) 1000 étant la fréquence en hz et 200 le temps en ms
je précise pour les personnes qui corrige je vais m'ammuser a tester la fonctionalité}


interface

uses
  sysutils, GestionEcran,Musique_bonus;

const 
  SOL_INCONNU  = 0;
  SOL_VIDE     = 1;
  SOL_HUB      = 99;
  BAT_AUCUN    = 0;

type
  // --- DEFINITION DES STRUCTURES ---

  TRessource = record
    Bois, Brique, Cuivre, Netherite, Titane, Paladium, Endium : Integer;
    CableElec, BlockConst, PCGamer : Integer;
  end;

  TMission = record
    Active : Boolean;
    TypeRessource : Integer;
    QuantiteDemandee : Integer;
    Recompense : Integer;
  end;

  TEmplacement = record
    EstDecouvert : Boolean;
    GisementType : Integer; 
    BatimentType : Integer; 
    Purete       : Integer; 
    Niveau       : Integer; 
    EnPanne      : Boolean; 
  end;

  TZone = record
    Nom : String;
    Inventaire : TRessource; 
    Emplacements : Array[1..10] of TEmplacement;
  end;


  TBilan = record
    EnergieProduite   : Integer;
    EnergieConsommee  : Integer;

    GainsParZone : array [1..3] of TRessource;
  end;

  TPartie = record
    Zones              : Array[1..3] of TZone;
    IndexZoneActive    : Integer;
    
    // Calendrier
    CompteurTotalJours : Integer;
    DateJour, DateMois, DateAnnee : Integer;
    Heure              : Integer;

    // Progression
    ascenseurConstruit : Boolean;
    MissionCourante    : TMission;
    DernierBilan       : TBilan;
    aTriche            : Boolean; 
    
    // Ressources Globales
    DolarsZANI         : Integer;
    Energie            : Integer;
    
    // Bonus
    BonusActif         : Boolean;
    TypeBonus          : Integer;
    JoursRestantsBonus : Integer;
  end;

var
  partie : TPartie; 

// --- DECLARATIONS DES PROCEDURES ---
procedure InitialiserPartie();
procedure LancerJeu();
procedure DemarrerPartie();
procedure PasserJourSuivant();
procedure AfficherBilanJournalier();
procedure MenuAdmin();
procedure ecranTitre();
procedure menu();
procedure quitter();
function ObtenirDateFormatee(): String;

implementation

uses
  unitIHM, unitINV, unitMission, unitChangeZone, unitBatiment, GestionDesEmplacements, unitWiki, windows;

// -----------------------------------------------------------------------------
// OUTILS
// -----------------------------------------------------------------------------

function ObtenirDateFormatee(): String;
var sJ, sM : String;
begin
  if partie.DateJour < 10 then
    sJ := '0' + IntToStr(partie.DateJour)
  else 
    sJ := IntToStr(partie.DateJour);

  if partie.DateMois < 10 then 
    sM := '0' + IntToStr(partie.DateMois) 
  else 
    sM := IntToStr(partie.DateMois);

  Result := sJ + '/' + sM + '/' + IntToStr(partie.DateAnnee);
end;

// -----------------------------------------------------------------------------
// INITIALISATION
// -----------------------------------------------------------------------------
procedure InitialiserPartie(); 
var i, j : Integer;
begin
  randomize;
  
  // 1. Configuration Date et Heure
  partie.CompteurTotalJours := 1;
  partie.DateJour := 1; 
  partie.DateMois := 1; 
  partie.DateAnnee := 2025;
  partie.Heure := 8;

  // 2. Configuration Joueur
  partie.IndexZoneActive := 1;
  partie.ascenseurConstruit := False;
  partie.MissionCourante.Active := False;
  partie.aTriche := False; 
  
  // 3. Ressources de départ
  partie.DolarsZANI := 2500; 
  partie.Energie := 100;    
  
  // 4. Initialisation des Zones
  for i := 1 to 3 do
  begin
    case i of
      1: partie.Zones[i].Nom := 'Viltrum';
      2: partie.Zones[i].Nom := 'Arcadia';
      3: partie.Zones[i].Nom := 'Titan';
    end;

    FillChar(partie.Zones[i].Inventaire, SizeOf(TRessource), 0);
    partie.Zones[i].Inventaire.Bois := 50; 

    // Initialisation des 10 Emplacements
    for j := 1 to 10 do
    begin
      partie.Zones[i].Emplacements[j].EnPanne := False;
      partie.Zones[i].Emplacements[j].Niveau := 0;
      partie.Zones[i].Emplacements[j].BatimentType := BAT_AUCUN;
      
      if j = 1 then 
      begin
         partie.Zones[i].Emplacements[j].GisementType := SOL_HUB;
         partie.Zones[i].Emplacements[j].EstDecouvert := True;
      end
      else 
      begin
         partie.Zones[i].Emplacements[j].GisementType := SOL_INCONNU; 
         partie.Zones[i].Emplacements[j].EstDecouvert := False; 
         partie.Zones[i].Emplacements[j].Purete := 0;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------
// GESTION DU TEMPS ET BILAN
// -----------------------------------------------------------------------------

procedure AfficherBilanJournalier();
var 
  b : TBilan;
  y : Integer;
  // affichage sous forme de tableau
  procedure LigneTab(nom : String; v1, v2, v3 : Integer; couleur : Byte);
  begin
    couleurTexte(couleur);
    deplacerCurseurXY(20, y); write(nom);
    
    // Zone 1
    if v1 > 0 then begin couleurTexte(LightGreen); deplacerCurseurXY(50, y); write('+', v1); end
    else begin couleurTexte(DarkGray); deplacerCurseurXY(50, y); write('-'); end;

    // Zone 2
    if v2 > 0 then begin couleurTexte(LightGreen); deplacerCurseurXY(90, y); write('+', v2); end
    else begin couleurTexte(DarkGray); deplacerCurseurXY(90, y); write('-'); end;

    // Zone 3
    if v3 > 0 then begin couleurTexte(LightGreen); deplacerCurseurXY(130, y); write('+', v3); end
    else begin couleurTexte(DarkGray); deplacerCurseurXY(130, y); write('-'); end;
    
    y := y + 1;
  end;
begin
 b := partie.DernierBilan;
  effacerEcran();
  
  dessinerCadreXY(10, 4, 160, 38, double, LightGreen, Black);
  
  couleurTexte(Yellow);
  deplacerCurseurXY(70, 6); writeln('BILAN JOURNALIER - ', ObtenirDateFormatee());
  

  y := 9;
  couleurTexte(LightCyan);
  deplacerCurseurXY(20, y); write('RESSOURCE');
  
  couleurTexte(LightMagenta);
  deplacerCurseurXY(50, y); write('VILTRUM');
  deplacerCurseurXY(90, y); write('ARCADIA');
  deplacerCurseurXY(130, y); write('TITAN');
  
  y := 10;
  couleurTexte(White);
  deplacerCurseurXY(15, y); write('---------------------------------------------------------------------------------------------------------------------------------------------------');
  y := 12;

  // --- LIGNES DE RESSOURCEs
  
  // Materiaux de base
  LigneTab('Bois',      b.GainsParZone[1].Bois,      b.GainsParZone[2].Bois,      b.GainsParZone[3].Bois,      LightBlue);
  LigneTab('Brique',    b.GainsParZone[1].Brique,    b.GainsParZone[2].Brique,    b.GainsParZone[3].Brique,    LightRed);
  y := y + 1; 

  // Minerais
  LigneTab('Cuivre',    b.GainsParZone[1].Cuivre,    b.GainsParZone[2].Cuivre,    b.GainsParZone[3].Cuivre,    White);
  LigneTab('Titane',    b.GainsParZone[1].Titane,    b.GainsParZone[2].Titane,    b.GainsParZone[3].Titane,    White);
  LigneTab('Netherite', b.GainsParZone[1].Netherite, b.GainsParZone[2].Netherite, b.GainsParZone[3].Netherite, LightRed);
  LigneTab('Palladium', b.GainsParZone[1].Paladium,  b.GainsParZone[2].Paladium,  b.GainsParZone[3].Paladium,  LightMagenta);
  LigneTab('Endium',    b.GainsParZone[1].Endium,    b.GainsParZone[2].Endium,    b.GainsParZone[3].Endium,    LightGreen);
  y := y + 1;

  // Produits Usines
  LigneTab('Cables',    b.GainsParZone[1].CableElec,  b.GainsParZone[2].CableElec,  b.GainsParZone[3].CableElec,  LightCyan);
  LigneTab('Blocs',     b.GainsParZone[1].BlockConst, b.GainsParZone[2].BlockConst, b.GainsParZone[3].BlockConst, LightCyan);
  LigneTab('PC Gamer',  b.GainsParZone[1].PCGamer,    b.GainsParZone[2].PCGamer,    b.GainsParZone[3].PCGamer,    Yellow);

  // --- ENERGIE ---
  y := 28;
  deplacerCurseurXY(15, y); write('------------------------------------------------------------------------------------------------------------------------------------------------------');
  y := 30;
  deplacerCurseurXY(20, y); couleurTexte(LightCyan); write('ENERGIE TOTALE PRODUITE : ');
  couleurTexte(LightGreen); write('+', b.EnergieProduite);
  couleurTexte(Yellow); 
  deplacerCurseurXY(78, 30); 
  writeln('APPUYEZ SUR ENTREE POUR COMMENCER LA JOURNEE');
  readln;
end;

procedure PasserJourSuivant();
begin
  partie.CompteurTotalJours += 1;
  partie.DateJour += 1;
  
  // Gestion fin de mois (30 jours)
  if partie.DateJour > 30 then
  begin
    partie.DateJour := 1;
    partie.DateMois += 1;   //ça va spam le plus "égal" partout
    
    if partie.DateMois > 12 then
    begin
      partie.DateMois := 1;
      partie.DateAnnee += 1;
    end;
  end;
  
  // Décrémentation Bonus
  if partie.BonusActif then
  begin
    partie.JoursRestantsBonus -= 1;
    
    if partie.JoursRestantsBonus <= 0 then 
    begin 
      partie.BonusActif := False; 
      partie.TypeBonus := 0; 
    end;
  end;
  
  // Calculs de production et affichage
  unitBatiment.RecolterProductionJournaliere();
  AfficherBilanJournalier();
end;

// -----------------------------------------------------------------------------
// MENU ADMIN (CHEAT MODE)
// -----------------------------------------------------------------------------
procedure MenuAdmin();
var choix, i, z : Integer;
begin
  repeat
    effacerEcran();
    dessinerCadreXY(50, 5, 150, 35, double, LightMagenta, Black);
    couleurTexte(LightMagenta); deplacerCurseurXY(95, 7); writeln('*** ADMIN / PROFS MODE ***');
    couleurTexte(White);
    deplacerCurseurXY(65, 10); writeln('1. AJOUTER 100 000 $');
    deplacerCurseurXY(65, 12); writeln('2. AJOUTER 10 000 ENERGIE');
    deplacerCurseurXY(65, 14); writeln('3. REMPLIR TOUS LES STOCKS');
    deplacerCurseurXY(65, 16); writeln('4. DECOUVRIR ZONE ACTIVE');
    deplacerCurseurXY(65, 18); writeln('5. REPARER TOUS LES BATIMENTS');
    deplacerCurseurXY(65, 20); writeln('6. CONSTRUIRE ASCENSEUR (Force)');
    deplacerCurseurXY(65, 22); writeln('0. RETOUR AU JEU');
    
    deplacerCurseurXY(95, 25); write('Choix Admin > ');
    try readln(choix); except choix := -1; end;
    
    // Marquage du tricheur si une action est faite c'est d'ailleurs pas bien petit tricheur va
    if choix <> 0 then 
      partie.aTriche := True;

    couleurTexte(Yellow); 
    deplacerCurseurXY(60, 24);
    
    case choix of
      1: begin 
           partie.DolarsZANI += 100000;  //vive le plus égal ça m'evite de faire par exemple a:=a+2
           write('Succes : +100 000 $ !'); 
         end;
         
      2: begin 
           partie.Energie += 10000; 
           write('Succes : Energie boostee !'); 
         end;
         
      3: begin
           for z := 1 to 3 do
           begin
             partie.Zones[z].Inventaire.Bois := 1000; 
             partie.Zones[z].Inventaire.Brique := 1000;
             partie.Zones[z].Inventaire.Cuivre := 1000; 
             partie.Zones[z].Inventaire.Titane := 1000;
             partie.Zones[z].Inventaire.Netherite := 1000; //ça permet de maxer tout
             partie.Zones[z].Inventaire.Paladium := 1000;
             partie.Zones[z].Inventaire.Endium := 1000; 
             partie.Zones[z].Inventaire.CableElec := 500;
             partie.Zones[z].Inventaire.BlockConst := 500; 
             partie.Zones[z].Inventaire.PCGamer := 500;
           end;
           write('Succes : Stocks remplis !');
         end;
         
      4: begin
           for i := 1 to 10 do 
           begin
              partie.Zones[partie.IndexZoneActive].Emplacements[i].EstDecouvert := True;
              
              if partie.Zones[partie.IndexZoneActive].Emplacements[i].GisementType = SOL_INCONNU then
                 partie.Zones[partie.IndexZoneActive].Emplacements[i].GisementType := SOL_VIDE;  {si tu vois pas de difference je te l'explique quand tu te balades tu as une chance de découvrir
                                                                                                  une zone vide ou un gisement la ça te debloques tout les zones vides}
           end;
           write('Succes : Carte revelee !');
         end;
         
      5: begin
           for z := 1 to 3 do 
             for i := 1 to 10 do 
               partie.Zones[z].Emplacements[i].EnPanne := False;
           write('Succes : Reparations terminees !');
         end;
         
      6: begin 
           partie.ascenseurConstruit := True; 
           write('Succes : Ascenseur construit !'); 
         end;
    end;
    
    if choix <> 0 then 
      attendre(800);
      
  until choix = 0;
end;

// -----------------------------------------------------------------------------
// BOUCLE PRINCIPALE (LANCER JEU)
// -----------------------------------------------------------------------------
procedure LancerJeu();
var
  choixJeu : Integer;
  actionEffectuee : Boolean;
  txt, titre : String; // Variables pour le centrage
  xCentre : Integer;
begin
  GestionDesEmplacements.ChargerZone(partie.IndexZoneActive);
  xCentre := 100; // Le milieu de ton écran 200

  repeat
    effacerEcran();
    actionEffectuee := False;
    
    // 1. CADRE GLOBAL
    dessinerCadreXY(2, 1, 198, 39, double, LightCyan, Black); 

    // 2. TITRE 
    couleurTexte(LightCyan); 
    titre := '--- SATISFACT''IUT : CONTROL CENTER ---';
    deplacerCurseurXY(xCentre - (Length(titre) div 2), 3); 
    write(titre);

 
    dessinerCadreXY(10, 6, 70, 30, simple, White, Black);
    
    couleurTexte(Yellow); 
    txt := '[ ETAT DU SYSTEME ]';
    deplacerCurseurXY(40 - (Length(txt) div 2), 6); 
    write(txt);

    couleurTexte(White); deplacerCurseurXY(15, 10); write('DATE MISSION : ');
    couleurTexte(LightGreen); write(ObtenirDateFormatee()); 

    couleurTexte(White); deplacerCurseurXY(15, 12); write('HEURE LOCALE : ');
    if partie.Heure >= 22 then couleurTexte(Red) else if partie.Heure >= 20 then couleurTexte(LightRed) else couleurTexte(LightGreen);
    write(partie.Heure, 'H00');

    couleurTexte(White); deplacerCurseurXY(15, 15); write('ZONE : ');
    couleurTexte(LightCyan); write(partie.Zones[partie.IndexZoneActive].Nom);
    
    couleurTexte(White); deplacerCurseurXY(15, 17); write('DolarsZANI : ');
    couleurTexte(Yellow); write(partie.DolarsZANI, ' $');

    deplacerCurseurXY(15, 21);
    if partie.BonusActif then begin couleurTexte(LightMagenta); write('BONUS : ACTIF (', partie.JoursRestantsBonus, 'j)'); end
    else begin couleurTexte(DarkGray); write('BONUS : INACTIF'); end;


    dessinerCadreXY(80, 6, 190, 30, simple, White, Black);
    
    couleurTexte(Yellow); 
    txt := '[ ACTIONS DISPONIBLES (COUT : 1H) ]';
    deplacerCurseurXY(135 - (Length(txt) div 2), 6); 
    write(txt);

    if partie.Heure >= 22 then couleurTexte(DarkGray) else couleurTexte(LightCyan);
    deplacerCurseurXY(90, 10);  write('1. Voyager vers une autre zone');
    
    if partie.Heure >= 22 then couleurTexte(DarkGray) else couleurTexte(LightGreen);
    deplacerCurseurXY(90, 13);  write('2. Consulter les Missions / Contrats');

    if partie.Heure >= 22 then couleurTexte(DarkGray) else couleurTexte(LightMagenta);
    deplacerCurseurXY(90, 16);  write('3. Activer un Bonus de Zone');

    if partie.Heure >= 20 then begin couleurTexte(DarkGray); deplacerCurseurXY(90, 19); write('4. Exploration (TROP SOMBRE / TARD)'); end
    else begin couleurTexte(LightBlue); deplacerCurseurXY(90, 19); write('4. Exploration & Construction'); end;

    couleurTexte(LightBlue); deplacerCurseurXY(90, 22); write('5. Wiki');

    deplacerCurseurXY(90, 23); write('----------------------------------------------------------------------');
    
    couleurTexte(White);
    deplacerCurseurXY(90, 25); write('8. Dormir (Passer au jour suivant)');
    deplacerCurseurXY(90, 27); write('9. Quitter vers le Menu Principal');
    
    // 5. ALERTES CENTREES
    if partie.Heure >= 22 then 
    begin 
       couleurTexte(LightRed); 
       txt := '! ALERTE : EPUISEMENT. VOUS DEVEZ DORMIR !';
       deplacerCurseurXY(xCentre - (Length(txt) div 2), 32); 
       write(txt); 
    end;
    
    if partie.Heure >= 24 then 
    begin 
       couleurTexte(Red); 
       txt := '! CRITIQUE : MINUIT PASSE. ACTIONS BLOQUEES !';
       deplacerCurseurXY(xCentre - (Length(txt) div 2), 33);
       write(txt); 
    end;

    // 6. TRICHEUR (Coin haut droit)
    if partie.aTriche then
    begin
       dessinerCadreXY(175, 2, 195, 4, simple, Red, Black);
       couleurTexte(LightRed); deplacerCurseurXY(179, 3); write('TRICHEUR :)');
    end;

    // 7. DEV MODE (Coin bas droit discret)
    couleurTexte(DarkGray); deplacerCurseurXY(175, 38); write('Dev: 99');

    // 8. SAISIE CENTREE
    couleurTexte(Yellow); 
    txt := 'ORDRE COMMANDANT ? > ';
    deplacerCurseurXY(xCentre - (Length(txt) div 2), 36); 
    write(txt); 
    
    couleurTexte(White);
    try readln(choixJeu); except choixJeu := 0; end;

    if choixJeu <> 0 then SonMenuMove(); 

    if (partie.Heure >= 24) and (choixJeu <> 8) and (choixJeu <> 9) and (choixJeu <> 99) then choixJeu := 0;

    case choixJeu of
      1, 2, 3: begin
                 if partie.Heure >= 22 then 
                 begin 
                    Musique_bonus.SonErreur();
                    couleurTexte(LightRed); 
                    txt := '>>> TROP FATIGUE ! <<<';
                    deplacerCurseurXY(xCentre - (Length(txt) div 2), 38); 
                    write(txt); 
                    attendre(1000);
                 end
                 else
                 begin
                    if choixJeu = 1 then unitChangeZone.ChangerDeZone()
                    else if choixJeu = 2 then unitMission.AfficherMission()
                    else if choixJeu = 3 then unitMission.BonusActif();
                    actionEffectuee := True; 
                 end;
               end;
      4: begin
           if partie.Heure >= 20 then 
           begin 
              Musique_bonus.SonErreur();
              couleurTexte(LightRed); 
              txt := '>>> IL FAIT NUIT ! <<<';
              deplacerCurseurXY(xCentre - (Length(txt) div 2), 38); 
              write(txt); 
              attendre(1000); 
           end
           else 
           begin 
              GestionDesEmplacements.LancerModeExploration(); 
              actionEffectuee := True; 
           end;
         end;
      5: wiki();
      8: begin
           SonSonar();
           PasserJourSuivant(); 
           partie.Heure := 8;   
           
           effacerEcran(); dessinerCadreXY(70, 15, 130, 25, double, Yellow, Black);
           couleurTexte(LightGreen); 
           txt := 'REPOS EN COURS... (Reveil a 08h00)';
           deplacerCurseurXY(100 - (Length(txt) div 2), 20); 
           writeln(txt);
           attendre(1500);
         end;
      9:ecranTitre();
      99: MenuAdmin(); 
    end;

    if actionEffectuee then partie.Heure += 1;
  until choixJeu = 9;
  if choixJeu=9 then SonQuitter;
end;

// Cette partie la sert donc a séparer l'ihm de la logique après aide on ma dit de faire comme ça
procedure ecranTitre(); 
begin 
  unitIHM.ecranTitreIHM(); 
  readln; 
  SonStartGame();
  menu(); 
end;
procedure menu(); 
var 
  c:Integer; 
begin 
  c := unitIHM.menuIHM(); 
  if c = 2 then quitter() 
  else 
    DemarrerPartie(); 
end;
procedure quitter(); 
begin 
  unitIHM.quitterIHM(); 
  readln; 
  end;
procedure DemarrerPartie(); 
begin 
  InitialiserPartie(); 
  LancerJeu(); 
end;

end.