unit unitMission;
{le but de cette unit est de gerer entierement le coter mission mais aussi le truc orbital permetant directement une efficacité a la programmation
voici donc la version final de cette unit}
{$mode delphi}{$H+}

interface

uses
  unitLogic, unitIHM, SysUtils, GestionEcran, Math, Musique_bonus;

// Génère une mission si aucune n'est active
procedure GenereNouvelleMission();

// Affiche le Terminal de Mission
procedure AfficherMission();

// Gère l'achat de bonus
procedure BonusActif();

// Gère la construction de l'ascenseur (utilisé par le menu construction)
procedure ConstruireAssenceur();

implementation

// -----------------------------------------------------------------------------
// LOGIQUE INTERNE (Pour gérer les noms et quantités)
// -----------------------------------------------------------------------------

function GetNomRessource(typeRes : Integer): String;
begin
  case typeRes of
    0: Result := 'BOIS (Materiau Composite)';
    1: Result := 'BRIQUE (Structure)';
    2: Result := 'CUIVRE (Conducteur)';
    3: Result := 'TITANE (Alliage Leger)';
    4: Result := 'NETHERITE (Blindage)';
    5: Result := 'PALLADIUM (Catalyseur)';
    6: Result := 'ENDIUM (Source Quantique)';
    else Result := 'MATERIAU INCONNU';
  end;
end;

function GetQuantiteJoueur(typeRes : Integer): Integer;
var id : Integer;
begin
  id := partie.IndexZoneActive;
  case typeRes of
    0: Result := partie.Zones[id].Inventaire.Bois;
    1: Result := partie.Zones[id].Inventaire.Brique;
    2: Result := partie.Zones[id].Inventaire.Cuivre;
    3: Result := partie.Zones[id].Inventaire.Titane;
    4: Result := partie.Zones[id].Inventaire.Netherite;
    5: Result := partie.Zones[id].Inventaire.Paladium;
    6: Result := partie.Zones[id].Inventaire.Endium;
    else Result := 0;
  end;
end;

procedure RetirerRessource(typeRes, qte : Integer);
var id : Integer;
begin
  id := partie.IndexZoneActive;
  case typeRes of
    0: partie.Zones[id].Inventaire.Bois -= qte;
    1: partie.Zones[id].Inventaire.Brique -= qte;
    2: partie.Zones[id].Inventaire.Cuivre -= qte;
    3: partie.Zones[id].Inventaire.Titane -= qte;
    4: partie.Zones[id].Inventaire.Netherite -= qte;
    5: partie.Zones[id].Inventaire.Paladium -= qte;
    6: partie.Zones[id].Inventaire.Endium -= qte;
  end;
end;

// -----------------------------------------------------------------------------
// GENERATION DE MISSION
// -----------------------------------------------------------------------------
procedure GenereNouvelleMission();
begin
  if partie.ascenseurConstruit then
  begin
    partie.MissionCourante.Active := true;
    // On demande une ressource aléatoire (0..6)
    partie.MissionCourante.TypeRessource := Random(7); 
    // Quantité entre 20 et 100
    partie.MissionCourante.QuantiteDemandee := (Random(9) + 2) * 10; 
    // Récompense : Prix de base x Quantité x Bonus 
    partie.MissionCourante.Recompense := partie.MissionCourante.QuantiteDemandee * (15 + (partie.MissionCourante.TypeRessource * 5)); 
  end;
end;

// -----------------------------------------------------------------------------
// CONSTRUCTION ASCENSEUR 
// -----------------------------------------------------------------------------
procedure ConstruireAssenceur();
begin
  if partie.ascenseurConstruit then
  begin
    couleurTexte(Red); writeln('Deja construit !'); attendre(1000);
  end
  else
  begin
    partie.ascenseurConstruit := true;
    writeln('Ascenseur operationnel !');
    SonMission(); // Petit son de victoire
  end;
end;

// -----------------------------------------------------------------------------
// INTERFACE GRAPHIQUE MISSION 
// -----------------------------------------------------------------------------
procedure AfficherMission();
var
  stockJoueur, demande, coutPenalite : Integer;
  pretALivrer : Boolean;
  choix : Integer;
  txtRes, msg, titre : String;
  xCentre : Integer;
begin
  // Le centre exact de ton cadre (qui va de 40 à 160) est 100
  xCentre := 100;

  // 1. Verif Ascenseur
  if not partie.ascenseurConstruit then
  begin
    effacerEcran();
    dessinerCadreXY(60, 15, 140, 25, double, Red, Black);
    
    msg := 'ERREUR 404 : ASCENSEUR ORBITAL NON DETECTE';
    couleurTexte(LightRed);
    deplacerCurseurXY(xCentre - (Length(msg) div 2), 19); 
    write(msg);
    
    msg := 'Veuillez construire l''ascenseur pour recevoir des contrats.';
    couleurTexte(White);
    deplacerCurseurXY(xCentre - (Length(msg) div 2), 21); 
    write(msg);
    
    Musique_bonus.SonErreur();
    attendre(2000);
    Exit;
  end;

  // 2. Générer si besoin
  if not partie.MissionCourante.Active then GenereNouvelleMission();

  // 3. Préparation des données
  demande := partie.MissionCourante.QuantiteDemandee;
  stockJoueur := GetQuantiteJoueur(partie.MissionCourante.TypeRessource);
  txtRes := GetNomRessource(partie.MissionCourante.TypeRessource);
  pretALivrer := (stockJoueur >= demande);
  coutPenalite := 500; 

  // 4. Affichage "Holo-Terminal"
  effacerEcran();
  
  // Cadre Global (40 -> 160)
  dessinerCadreXY(40, 5, 160, 35, double, LightCyan, Black);
  
  // En-tête Centré
  dessinerCadreXY(80, 3, 120, 5, simple, LightCyan, Black);
  couleurTexte(Yellow);
  titre := 'CONTRAT GALACTIQUE';
  deplacerCurseurXY(xCentre - (Length(titre) div 2), 4); 
  write(titre);

  // Infos Gauche
  couleurTexte(LightGray);
  deplacerCurseurXY(45, 8);  write('CLIENT :'); couleurTexte(White); write(' IUT DIJON - Dept Info');
  couleurTexte(LightGray);
  deplacerCurseurXY(45, 10); write('STATUT :'); 
  if pretALivrer then begin couleurTexte(LightGreen); write(' PRET POUR ENVOI'); end
  else begin couleurTexte(LightRed); write(' STOCK INSUFFISANT'); end;

  // Cadre Requisition Centré
  dessinerCadreXY(50, 13, 150, 25, simple, White, Black);
  couleurTexte(LightCyan);
  titre := '[ REQUISITION ]';
  deplacerCurseurXY(xCentre - (Length(titre) div 2), 13);
  write(titre);
  
  // Détails Requisition (Centrage relatif visuel)
  couleurTexte(Yellow);
  msg := 'CIBLE : ' + txtRes;
  deplacerCurseurXY(xCentre - (Length(msg) div 2), 16); // Centré
  write(msg);
  
  // Ligne Demande / Stock (Un peu écartée pour faire propre)
  deplacerCurseurXY(60, 19); write('DEMANDE : '); couleurTexte(LightRed); write(demande, ' u.');
  deplacerCurseurXY(110, 19); couleurTexte(Yellow); write('STOCK : '); // Décalé à 110 pour équilibrer
  if pretALivrer then couleurTexte(LightGreen) else couleurTexte(Red); write(stockJoueur, ' u.');

  // Prime Centrée
  dessinerCadreXY(80, 22, 120, 24, simple, LightGreen, Black);
  couleurTexte(LightGreen);
  msg := 'PRIME : ' + IntToStr(partie.MissionCourante.Recompense) + ' $';
  deplacerCurseurXY(xCentre - (Length(msg) div 2), 23);
  write(msg);

  // --- ACTIONS ---
  couleurTexte(White);
  deplacerCurseurXY(60, 30); write('DECISION :');
  
  // Bouton 1 (Gauche)
  if pretALivrer then begin couleurTexte(LightGreen); deplacerCurseurXY(55, 32); write('[1] EXPEDIER MARCHANDISE'); end
  else begin couleurTexte(DarkGray); deplacerCurseurXY(55, 32); write('[1] EXPEDIER (Manque stock)'); end;
  
  // Bouton 2 (Droite)
  couleurTexte(LightRed); 
  deplacerCurseurXY(110, 32); write('[2] RESILIER (Cout: -', coutPenalite, '$)');
  
  // Bouton 0 (Centre bas)
  couleurTexte(White);
  msg := '[0] REFLECHIR / RETOUR';
  deplacerCurseurXY(xCentre - (Length(msg) div 2), 34);
  write(msg);

  // Saisie Centrée
  couleurTexte(LightCyan);
  msg := 'CHOIX > ';
  deplacerCurseurXY(xCentre - 5, 36); // On décale un peu pour que la saisie soit au milieu
  write(msg);
  try readln(choix); except choix := -1; end;

  // --- TRAITEMENT ET MESSAGES ---
  
  // SUCCES
  if (choix = 1) and pretALivrer then
  begin
    RetirerRessource(partie.MissionCourante.TypeRessource, demande);
    partie.DolarsZANI += partie.MissionCourante.Recompense;
    partie.MissionCourante.Active := False;
    
    Musique_bonus.SonMission(); 
    
    couleurTexte(LightGreen);
    msg := '>>> TRANSFERT REUSSI ! PAIEMENT RECU. <<<';
    deplacerCurseurXY(xCentre - (Length(msg) div 2), 27); // Affiché juste sous la prime
    write(msg);
    attendre(2000);
  end
  // ECHEC STOCK
  else if (choix = 1) and (not pretALivrer) then
  begin
    Musique_bonus.SonErreur();
    couleurTexte(Red);
    msg := '>>> ERREUR : STOCK INSUFFISANT ! <<<';
    deplacerCurseurXY(xCentre - (Length(msg) div 2), 27);
    write(msg);
    attendre(1500);
  end
  // ABANDON
  else if (choix = 2) then
  begin
    if partie.DolarsZANI >= coutPenalite then
    begin
       partie.DolarsZANI -= coutPenalite;
       partie.MissionCourante.Active := False;
       Musique_bonus.SonErreur(); 
       
       effacerEcran();
       dessinerCadreXY(60, 15, 140, 25, double, Red, Black);
       couleurTexte(LightRed);
       
       msg := 'CONTRAT ROMPU';
       deplacerCurseurXY(xCentre - (Length(msg) div 2), 19); write(msg);
       
       couleurTexte(White);
       msg := 'Penalite de ' + IntToStr(coutPenalite) + '$ prelevee.';
       deplacerCurseurXY(xCentre - (Length(msg) div 2), 21); write(msg);
       
       attendre(2000);
    end
    else
    begin
       Musique_bonus.SonErreur();
       couleurTexte(Red);
       msg := '>>> FONDS INSUFFISANTS POUR LA PENALITE ! <<<';
       deplacerCurseurXY(xCentre - (Length(msg) div 2), 27);
       write(msg);
       attendre(1500);
    end;
  end;
end;
// -----------------------------------------------------------------------------
// BONUS laaaaaaaaaaaa BOUTIQUE
// -----------------------------------------------------------------------------
procedure BonusActif();
var choix : Integer;
begin
  if not partie.ascenseurConstruit then
  begin
    // Pas de bonus sans ascenseur (logistique)
    effacerEcran();
    dessinerCadreXY(60, 15, 140, 25, double, Red, Black);
    couleurTexte(LightRed);
    deplacerCurseurXY(70, 19); writeln('ACCES REFUSE : ASCENSEUR REQUIS');
    Musique_bonus.SonErreur();
    attendre(1500); Exit;
  end;

  if partie.BonusActif then
  begin
    effacerEcran();
    dessinerCadreXY(60, 15, 140, 25, double, LightMagenta, Black);
    couleurTexte(Yellow);
    deplacerCurseurXY(75, 19); writeln('BONUS DEJA ACTIF !');
    deplacerCurseurXY(70, 21); writeln('Temps restant : ', partie.JoursRestantsBonus, ' jours');
    attendre(2000); Exit;
  end;

  // Menu Bonus
  effacerEcran();
  dessinerCadreXY(40, 5, 160, 35, double, LightMagenta, Black);
  couleurTexte(LightMagenta);
  deplacerCurseurXY(80, 7); writeln('BOUTIQUE DE BONUS (Duree: 5 jours)');
  couleurTexte(White);

  deplacerCurseurXY(60, 12); writeln('1. PROTOCOLE INDUSTRIEL (Cout: 2000$)');
  couleurTexte(LightGray); deplacerCurseurXY(65, 13); writeln('> Double la production des mines');
  
  couleurTexte(White);
  deplacerCurseurXY(60, 16); writeln('2. SUBVENTION IUT (Cout: 2000$)');
  couleurTexte(LightGray); deplacerCurseurXY(65, 17); writeln('> Divise les couts de construction par 2');
  
  couleurTexte(White);
  deplacerCurseurXY(60, 20); writeln('3. SUPRA-CONDUCTEURS (Cout: 2000$)');
  couleurTexte(LightGray); deplacerCurseurXY(65, 21); writeln('> Double la production des centrales');

  deplacerCurseurXY(60, 26); writeln('0. Retour');

  couleurTexte(LightMagenta); deplacerCurseurXY(90, 28); write('ACHAT > ');
  try readln(choix); except choix := 0; end;

  if (choix in [1..3]) then
  begin
    if partie.DolarsZANI >= 2000 then
    begin
       partie.DolarsZANI -= 2000;
       partie.BonusActif := True;
       partie.TypeBonus := choix;
       partie.JoursRestantsBonus := 5;
       
       Musique_bonus.SonMission(); // Son de réussite
       couleurTexte(LightGreen);
       deplacerCurseurXY(80, 30); writeln('BONUS ACTIVE !');
       attendre(1500);
    end
    else
    begin
       Musique_bonus.SonErreur();
       couleurTexte(Red);
       deplacerCurseurXY(80, 30); writeln('Fonds insuffisants (2000$ req.)');
       attendre(1500);
    end;
  end;
end;

end.