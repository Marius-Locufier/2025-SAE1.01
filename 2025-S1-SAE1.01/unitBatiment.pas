unit unitBatiment;

{$mode delphi}

interface

uses
  SysUtils, GestionEcran;

// Procédures de construction 
procedure ConstruireMine(index : Integer; var msg : String);
procedure ConstruireUsine(index : Integer; var msg : String);
procedure ConstruireCentrale(index : Integer; var msg : String); 

// Procédures de gestion (Amélioration, Modification, Vente)
procedure AmeliorerBatiment(index : Integer; var msg : String);
procedure ModifierUsine(index : Integer; var msg : String);
procedure MenuVente(var msg : String); 

// Procédure de récolte 
procedure RecolterProductionJournaliere();

procedure ReparerBatiment(index : Integer; var msg : String);
procedure GenererPannesAleatoires();

implementation

uses
  unitLogic, GestionDesEmplacements, Musique_bonus; 

procedure GenererPannesAleatoires();
var
  i, chance : Integer;
begin
  // On parcourt les 10 emplacements de la zone active
  for i := 1 to MAX_EMPLACEMENTS do
  begin
    // Si il y a un batiment et qu'il n'est pas déjà en panne
    if (BatimentsMemoire[i] <> BAT_AUCUN) and (PanneMemoire[i] = 0) then
    begin
      chance := Random(100); // 0 à 99
      if chance = 0 then // 1% de chance
      begin
         PanneMemoire[i] := 1; // Le bâtiment tombe en panne 
      end;
    end;
  end;
end;

procedure ReparerBatiment(index : Integer; var msg : String);
var
  coutReparation, choix : Integer; 
begin
  coutReparation := 100;

  // On vérifie si le bâtiment est réellement en panne (1 = Panne)
  if GestionDesEmplacements.PanneMemoire[index] = 0 then
  begin
    msg := 'Ce batiment fonctionne tres bien.';
    Exit;
  end;

  dessinerCadreXY(50, 15, 150, 25, double, LightRed, Black);
  deplacerCurseurXY(60, 17); writeln('ALERTE : BATIMENT EN PANNE !');
  deplacerCurseurXY(60, 18); writeln('Cout des reparations : ', coutReparation, ' DolarsZANI');
  deplacerCurseurXY(60, 20); writeln('[1] REPARER MAINTENANT');
  deplacerCurseurXY(60, 21); writeln('[0] LAISSER A L''ABANDON');
  deplacerCurseurXY(60, 23); write('Choix > ');
  
  try
    readln(choix); 
    
    if choix = 1 then
    begin
      if partie.DolarsZANI >= coutReparation then
      begin
        partie.DolarsZANI := partie.DolarsZANI - coutReparation;
        GestionDesEmplacements.PanneMemoire[index] := 0; // 0 = Marche, 1 = Panne
        msg := 'Reparations effectuees (-100$)';
        
        // --- SON ---
      SonConstruction(); 
      end
      else
        msg := 'Fonds insuffisants pour reparer !';
    end
    else
      msg := 'Reparation annulee.';
  except
    msg := 'Erreur saisie.';
  end;
end;

// -----------------------------------------------------------------------------
// CONSTRUCTION MINE
// -----------------------------------------------------------------------------
procedure ConstruireMine(index : Integer; var msg : String);
var
  coutArgent, coutMat, typeMatReq : Integer;
  nomMat : String;
  choix : Integer;
  idZone : Integer;
begin
  idZone := partie.IndexZoneActive;
  
  case GestionDesEmplacements.TerrainMemoire[index] of
    // --- REEQUILIBRAGE PRIX MINES ---
    RES_CUIVRE : begin coutArgent := 300; // (Avant 200)
    coutMat := 50; typeMatReq := 0;  nomMat := 'Bois'; end;

    RES_TITANE : begin coutArgent := 800; // (Avant 600)   
    coutMat := 50; typeMatReq := RES_CUIVRE; nomMat := 'Cuivre'; end;

    RES_NETHERITE : begin coutArgent := 1500;  
    coutMat := 50; typeMatReq := RES_TITANE; nomMat := 'Titane'; end;

    RES_PALLADIUM : begin coutArgent := 5000;  
    coutMat := 50; typeMatReq := RES_NETHERITE; nomMat := 'Netherite'; end;

    RES_Endium : begin coutArgent := 20000; 
    coutMat := 50; typeMatReq := RES_PALLADIUM; nomMat := 'Palladium'; end;

    else 
    begin
      msg := 'Rien a construire ici.';
      Exit;
    end;
  end;

  if (partie.BonusActif) and (partie.TypeBonus = 2) then
  begin
     coutArgent := coutArgent div 2;
     coutMat := coutMat div 2;
  end;

  dessinerCadreXY(50, 10, 150, 25, double, LightGreen, Black);
  deplacerCurseurXY(60, 12); writeln('CONSTRUCTION MINE (Emplacement ', index, ')');
  deplacerCurseurXY(60, 14); writeln('Cout en Argent    : ', coutArgent, ' DolarsZANI');
  deplacerCurseurXY(60, 15); writeln('Cout en Materiaux : ', coutMat, ' ', nomMat);
  deplacerCurseurXY(60, 17); writeln('-----------------------------');
  deplacerCurseurXY(60, 19); writeln('[1] Payer en ARGENT');
  deplacerCurseurXY(60, 20); writeln('[2] Payer en MATERIAUX');
  deplacerCurseurXY(60, 21); writeln('[0] Annuler');
  
  deplacerCurseurXY(60, 23); write('Votre choix > ');
  try readln(choix); except choix := 0; end;

  if choix = 0 then begin msg := 'Annule.'; Exit; end;

  if choix = 1 then
  begin
    if partie.DolarsZANI >= coutArgent then
    begin
      partie.DolarsZANI := partie.DolarsZANI - coutArgent;
      GestionDesEmplacements.BatimentsMemoire[index] := BAT_MINE;
      GestionDesEmplacements.NiveauBatiments[index] := 1;
      msg := 'Mine achetee avec succes !';
      
      // --- SON ---
      SonConstruction();
    end
    else msg := 'Pas assez d''argent !';
  end
  else if choix = 2 then
  begin
    if typeMatReq = 0 then 
    begin
       if partie.Zones[idZone].Inventaire.Bois >= coutMat then
       begin
         partie.Zones[idZone].Inventaire.Bois := partie.Zones[idZone].Inventaire.Bois - coutMat;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_MINE;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Mine construite (Bois) !';
         
         // --- SON ---
         SonConstruction();
       end else msg := 'Pas assez de Bois !';
    end
    else if typeMatReq = RES_CUIVRE then
    begin
       if partie.Zones[idZone].Inventaire.Cuivre >= coutMat then
       begin
         partie.Zones[idZone].Inventaire.Cuivre := partie.Zones[idZone].Inventaire.Cuivre - coutMat;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_MINE;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Mine construite (Cuivre) !';
         
         // --- SON ---
         SonConstruction();
       end else msg := 'Pas assez de Cuivre !';
    end
    else msg := 'Materiaux insuffisants.';
  end;
end;

// -----------------------------------------------------------------------------
// CONSTRUCTION USINE
// -----------------------------------------------------------------------------
procedure ConstruireUsine(index : Integer; var msg : String);
var
  choix, cout, coutMat, idZone : Integer;
begin
  idZone := partie.IndexZoneActive;
  cout := 500; // --- BAISSE PRIX (Avant 1000) ---
  coutMat := 50; 

  if (partie.BonusActif) and (partie.TypeBonus = 2) then
  begin
     cout := cout div 2;
     coutMat := coutMat div 2;
  end;

  dessinerCadreXY(50, 8, 150, 28, double, LightMagenta, Black);
  deplacerCurseurXY(60, 10); writeln('CONSTRUCTION USINE');
  deplacerCurseurXY(60, 11); writeln('Cout construction : ', cout, ' DolarsZANI');
  
  deplacerCurseurXY(60, 12); writeln('[1] CARRIERE    (',cout,' $) -> Produit Brique');
  deplacerCurseurXY(60, 13); writeln('[2] FORET       (',cout,' $) -> Produit Bois');
  deplacerCurseurXY(60, 15); writeln('[3] USINE CABLE (',coutMat,' Cuivre + ',coutMat,' Titane)');
  deplacerCurseurXY(60, 16); writeln('[4] USINE BLOC  (',coutMat,' Bois + ',coutMat,' Brique)');
  deplacerCurseurXY(60, 17); writeln('[5] USINE PC    (',coutMat,' Palladium + ',coutMat,' Netherite)');
  deplacerCurseurXY(60, 19); writeln('[0] Annuler');
  
  deplacerCurseurXY(60, 21); write('Choix > '); try readln(choix); except choix := 0; end;

  if choix = 0 then Exit;

  case choix of
    1: if partie.DolarsZANI >= cout then
       begin
         partie.DolarsZANI := partie.DolarsZANI - cout;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_CARRIERE;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Carriere construite !';
         SonConstruction(); // --- SON ---
       end else msg := 'Pas assez d''argent !';

    2: if partie.DolarsZANI >= cout then
       begin
         partie.DolarsZANI := partie.DolarsZANI - cout;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_FORET;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Foret plantee !';
         SonConstruction(); // --- SON ---
       end else msg := 'Pas assez d''argent !';

    3: if (partie.Zones[idZone].Inventaire.Cuivre >= coutMat) and (partie.Zones[idZone].Inventaire.Titane >= coutMat) then
       begin
         partie.Zones[idZone].Inventaire.Cuivre -= coutMat;
         partie.Zones[idZone].Inventaire.Titane -= coutMat;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_USINE_CABLE;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Usine a cables construite !';
         SonConstruction(); // --- SON ---
       end else msg := 'Manque Cuivre ou Titane !';

    4: if (partie.Zones[idZone].Inventaire.Bois >= coutMat) and (partie.Zones[idZone].Inventaire.Brique >= coutMat) then
       begin
         partie.Zones[idZone].Inventaire.Bois -= coutMat;
         partie.Zones[idZone].Inventaire.Brique -= coutMat;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_USINE_BLOCK;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Usine a blocs construite !';
         SonConstruction(); // --- SON ---
       end else msg := 'Manque Bois ou Brique !';

    5: if (partie.Zones[idZone].Inventaire.Paladium >= coutMat) and (partie.Zones[idZone].Inventaire.Netherite >= coutMat) then
       begin
         partie.Zones[idZone].Inventaire.Paladium -= coutMat;
         partie.Zones[idZone].Inventaire.Netherite -= coutMat;
         GestionDesEmplacements.BatimentsMemoire[index] := BAT_USINE_PC;
         GestionDesEmplacements.NiveauBatiments[index] := 1;
         msg := 'Usine PC Gamer construite !';
         SonConstruction(); // --- SON ---
       end else msg := 'Manque Palladium ou Netherite !';
  end;
end;

procedure ModifierUsine(index : Integer; var msg : String);
begin
  ConstruireUsine(index, msg);
end;

// -----------------------------------------------------------------------------
// CONSTRUCTION CENTRALE
// -----------------------------------------------------------------------------
procedure ConstruireCentrale(index : Integer; var msg : String);
var
  cout : Integer;
begin
  cout := 500; // --- PRIX BAISSÉ (Avant 2000) ---
  
  if (partie.BonusActif) and (partie.TypeBonus = 2) then
     cout := cout div 2;

  dessinerCadreXY(50, 15, 150, 25, double, Yellow, Black);
  deplacerCurseurXY(60, 17); writeln('CONSTRUIRE CENTRALE ELECTRIQUE ?');
  deplacerCurseurXY(60, 18); writeln('Cout : ', cout, ' DolarsZANI');
  // --- PROD AUGMENTÉE ---
  deplacerCurseurXY(60, 19); writeln('Production : +50 Energie / jour'); 
  
  deplacerCurseurXY(60, 21); writeln('[1] OUI   [0] NON');
  deplacerCurseurXY(60, 22); write('Choix > ');
  try readln; except end; // ça permet d'attendre en gros
  
  if partie.DolarsZANI >= cout then
  begin
    partie.DolarsZANI := partie.DolarsZANI - cout;
    GestionDesEmplacements.BatimentsMemoire[index] := BAT_CENTRALE;
    GestionDesEmplacements.NiveauBatiments[index] := 1;
    msg := 'Centrale operationnelle !';
    
    // --- SON ---
    SonConstruction();
  end
  else
    msg := 'Pas assez de DolarsZANI !';
end;

// Augmente le niveau d'un bâtiment existant 
procedure AmeliorerBatiment(index : Integer; var msg : String);
var
  lvlActuel, coutUpgrade, idZone, choix : Integer;
begin
  idZone := partie.IndexZoneActive;
  lvlActuel := GestionDesEmplacements.NiveauBatiments[index];

  if lvlActuel = 0 then lvlActuel := 1;
  if lvlActuel >= 3 then begin msg := 'Niveau MAX (3).'; Exit; end;

  // Calcul du coût
  coutUpgrade := 500 * lvlActuel * 2;

  if (partie.BonusActif) and (partie.TypeBonus = 2) then
     coutUpgrade := coutUpgrade div 2;

  dessinerCadreXY(50, 10, 150, 20, double, LightCyan, Black);
  deplacerCurseurXY(60, 12); writeln('AMELIORATION BATIMENT');
  deplacerCurseurXY(60, 13); writeln('Niveau : ', lvlActuel, ' -> ', lvlActuel + 1);
  deplacerCurseurXY(60, 15); writeln('Cout   : ', coutUpgrade, ' DolarsZANI');
  deplacerCurseurXY(60, 17); writeln('[1] Confirmer   [0] Annuler');
  
  deplacerCurseurXY(60, 19); write('Choix > '); readln(choix);

  if choix = 1 then
  begin
    if partie.DolarsZANI >= coutUpgrade then
    begin
      partie.DolarsZANI := partie.DolarsZANI - coutUpgrade;
      GestionDesEmplacements.NiveauBatiments[index] := lvlActuel + 1;
      msg := 'Amelioration reussie !';
      
      // --- SON (UPGRADE) ---
      SonUpgrade(); 
    end
    else msg := 'Pas assez d''argent !';
  end;
end;

// -----------------------------------------------------------------------------
// MENU VENTE 
// -----------------------------------------------------------------------------
procedure MenuVente(var msg : String);
var
  choix, qte, gain, idZone : Integer;
begin
  idZone := partie.IndexZoneActive;
  
  effacerEcran();
  dessinerCadreXY(60, 5, 140, 30, double, LightGreen, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(85, 7); writeln('MARCHE GALACTIQUE');
  couleurTexte(White);
  
  deplacerCurseurXY(70, 10); writeln('VENDRE PAR PACK DE 10 UNITES :');
  // --- REEQUILIBRAGE PRIX VENTE ---
  deplacerCurseurXY(70, 12); writeln('1. Bois      (+10 $)');
  deplacerCurseurXY(70, 12); writeln('2. CUIVRE    (+25 $)');   
  deplacerCurseurXY(70, 13); writeln('3. TITANE    (+60 $)');  
  deplacerCurseurXY(70, 14); writeln('4. NETHERITE (+150 $)');  
  deplacerCurseurXY(70, 15); writeln('5. PALLADIUM (+400 $)');  
  deplacerCurseurXY(70, 16); writeln('6. ENDIUM    (+1500 $)');
  deplacerCurseurXY(70, 16); writeln('9. Vendre Tout');
  // --------------------------------
  
  deplacerCurseurXY(70, 18); writeln('0. Retour');
  deplacerCurseurXY(70, 20); write('Votre choix > ');
  
  try readln(choix); except choix := 0; end;
  
  if choix = 0 then begin msg := 'Retour exploration.'; Exit; end;
  
  qte := 10;
  gain := 0;
  
  case choix of
    1: if partie.Zones[idZone].Inventaire.Bois >= qte then begin partie.Zones[idZone].Inventaire.Bois -= qte; gain :=10; end else msg := 'Pas assez de Bois !';
    2: if partie.Zones[idZone].Inventaire.Cuivre >= qte then begin partie.Zones[idZone].Inventaire.Cuivre -= qte; gain := 25; end else msg := 'Pas assez de Cuivre !';
    3: if partie.Zones[idZone].Inventaire.Titane >= qte then begin partie.Zones[idZone].Inventaire.Titane -= qte; gain := 60; end else msg := 'Pas assez de Titane !';
    4: if partie.Zones[idZone].Inventaire.Netherite >= qte then begin partie.Zones[idZone].Inventaire.Netherite -= qte; gain := 150; end else msg := 'Pas assez de Netherite !';
    5: if partie.Zones[idZone].Inventaire.Paladium >= qte then begin partie.Zones[idZone].Inventaire.Paladium -= qte; gain := 400; end else msg := 'Pas assez de Palladium !';
    6: if partie.Zones[idZone].Inventaire.Endium >= qte then begin partie.Zones[idZone].Inventaire.Endium -= qte; gain := 1500; end else msg := 'Pas assez d''Endium !';
    9: begin
         
         gain := gain + (partie.Zones[idZone].Inventaire.Bois * 10) div 10;
         gain := gain + (partie.Zones[idZone].Inventaire.Cuivre * 25) div 10;
         gain := gain + (partie.Zones[idZone].Inventaire.Titane * 60) div 10;
         gain := gain + (partie.Zones[idZone].Inventaire.Netherite * 150) div 10;
         gain := gain + (partie.Zones[idZone].Inventaire.Paladium * 400) div 10;
         gain := gain + (partie.Zones[idZone].Inventaire.Endium * 1500) div 10;
         
         // On vide tout
         partie.Zones[idZone].Inventaire.Bois := 0;
         partie.Zones[idZone].Inventaire.Cuivre := 0;
         partie.Zones[idZone].Inventaire.Titane := 0;
         partie.Zones[idZone].Inventaire.Netherite := 0;
         partie.Zones[idZone].Inventaire.Paladium := 0;
         partie.Zones[idZone].Inventaire.Endium := 0;
         
         if gain = 0 then msg := 'Rien a vendre !'
         else msg := 'Vente globale terminee !';
       end;
  end;
  
  if gain > 0 then
  begin
    partie.DolarsZANI := partie.DolarsZANI + gain;
    msg := 'Vente reussie ! +' + IntToStr(gain) + '$';
    
    // --- SON ---
    SonCash(); 
  end;
end;

// RECOLTE
procedure RecolterProductionJournaliere();
var
  z, i, prodBase, gain, niveau, coutEnergie : Integer;
begin
  // 1. INITIALISATION DU BILAN A ZERO
  FillChar(partie.DernierBilan, SizeOf(TBilan), 0);

  // ===========================================================================
  // PHASE 1 : PRODUCTION D'ELECTRICITE
  // ===========================================================================
  for z := 1 to 3 do
  begin
    for i := 1 to MAX_EMPLACEMENTS do
    begin
      if (partie.Zones[z].Emplacements[i].BatimentType = BAT_CENTRALE) 
         and (partie.Zones[z].Emplacements[i].EnPanne = False) then
      begin
          niveau := partie.Zones[z].Emplacements[i].Niveau;
          gain := 50; 
          if (partie.BonusActif) and (partie.TypeBonus = 3) then gain := gain * 2; 

          partie.Energie := partie.Energie + (gain * niveau);
          
          // STATS BILAN
          partie.DernierBilan.EnergieProduite := partie.DernierBilan.EnergieProduite + (gain * niveau);
      end;
    end;
  end;

  // ===========================================================================
  // PHASE 2 : CONSOMMATION ET PRODUCTION
  // ===========================================================================
  for z := 1 to 3 do
  begin
    for i := 1 to MAX_EMPLACEMENTS do
    begin
      niveau := partie.Zones[z].Emplacements[i].Niveau;

      if (partie.Zones[z].Emplacements[i].BatimentType <> BAT_AUCUN) 
         and (partie.Zones[z].Emplacements[i].BatimentType <> BAT_CENTRALE) then
      begin
        if partie.Zones[z].Emplacements[i].EnPanne = False then
        begin
           coutEnergie := 0;
           if partie.Zones[z].Emplacements[i].BatimentType = BAT_MINE then coutEnergie := 5 * niveau
           else coutEnergie := 10 * niveau;

           if partie.Energie >= coutEnergie then
           begin
             partie.Energie := partie.Energie - coutEnergie;

             partie.DernierBilan.EnergieConsommee := partie.DernierBilan.EnergieConsommee + coutEnergie;
             
             if partie.Zones[z].Emplacements[i].BatimentType = BAT_MINE then
             begin
                prodBase := 10; 
                case partie.Zones[z].Emplacements[i].Purete of
                  RANG_B: prodBase := 20; 
                  RANG_A: prodBase := 40; 
                  RANG_S: prodBase := 80;
                end;

                gain := prodBase * niveau;

                if (partie.BonusActif) and (partie.TypeBonus = 1) then
                   gain := gain * 2;

                case partie.Zones[z].Emplacements[i].GisementType of
                  RES_CUIVRE    : begin partie.Zones[z].Inventaire.Cuivre := partie.Zones[z].Inventaire.Cuivre + gain; partie.DernierBilan.GainsParZone[z].Cuivre := partie.DernierBilan.GainsParZone[z].Cuivre + gain;  end;
                  RES_TITANE    : begin partie.Zones[z].Inventaire.Titane := partie.Zones[z].Inventaire.Titane + gain; partie.DernierBilan.GainsParZone[z].Titane := partie.DernierBilan.GainsParZone[z].Titane + gain;  end;
                  RES_NETHERITE : begin partie.Zones[z].Inventaire.Netherite := partie.Zones[z].Inventaire.Netherite + gain; partie.DernierBilan.GainsParZone[z].Netherite := partie.DernierBilan.GainsParZone[z].Netherite + gain;  end;
                  RES_PALLADIUM : begin partie.Zones[z].Inventaire.Paladium := partie.Zones[z].Inventaire.Paladium + gain; partie.DernierBilan.GainsParZone[z].Paladium := partie.DernierBilan.GainsParZone[z].Paladium + gain;  end;
                  RES_Endium    : begin partie.Zones[z].Inventaire.Endium := partie.Zones[z].Inventaire.Endium + gain; partie.DernierBilan.GainsParZone[z].Endium := partie.DernierBilan.GainsParZone[z].Endium + gain;  end;
                end;
             end
             else 
             begin
                // USINES
                case partie.Zones[z].Emplacements[i].BatimentType of
                  BAT_CARRIERE    : begin partie.Zones[z].Inventaire.Brique := partie.Zones[z].Inventaire.Brique + (10 * niveau); partie.DernierBilan.GainsParZone[z].Brique := partie.DernierBilan.GainsParZone[z].Brique + (10 * niveau); end;
                  BAT_FORET       : begin partie.Zones[z].Inventaire.Bois := partie.Zones[z].Inventaire.Bois + (10 * niveau); partie.DernierBilan.GainsParZone[z].Bois := partie.DernierBilan.GainsParZone[z].Bois + (10 * niveau); end;
                  BAT_USINE_CABLE : begin partie.Zones[z].Inventaire.CableElec := partie.Zones[z].Inventaire.CableElec + (5 * niveau); partie.DernierBilan.GainsParZone[z].CableElec := partie.DernierBilan.GainsParZone[z].CableElec + (5 * niveau); end;
                  BAT_USINE_BLOCK : begin partie.Zones[z].Inventaire.BlockConst := partie.Zones[z].Inventaire.BlockConst + (5 * niveau); partie.DernierBilan.GainsParZone[z].BlockConst := partie.DernierBilan.GainsParZone[z].BlockConst + (5 * niveau); end;
                  BAT_USINE_PC    : begin partie.Zones[z].Inventaire.PCGamer := partie.Zones[z].Inventaire.PCGamer + (1 * niveau); partie.DernierBilan.GainsParZone[z].PCGamer:= partie.DernierBilan.GainsParZone[z].PCGamer + (1 * niveau); end;
                end;
             end;
           end;
        end;
      end;
    end;
  end;
end;

end.