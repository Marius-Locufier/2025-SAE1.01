unit unitChangeZone;

{$mode delphi}{$H+}

interface

procedure ChangerDeZone();

implementation

uses
  unitLogic, GestionEcran, SysUtils, unitIHM, GestionDesEmplacements; 

procedure ChangerDeZone();
var
  i, choix, ancienneZone : Integer;
  txt : String;
begin
  // --- 1. VERIFICATION DE L'ASCENSEUR ---
  if partie.ascenseurConstruit = False then
  begin
    effacerEcran();
    // Cadre rouge centré (Largeur 80: 60 à 140)
    dessinerCadreXY(2, 1, 199, 39, double, Red, Black);
    
    couleurTexte(LightRed);
    txt := 'ACCES REFUSE : ASCENSEUR HORS LIGNE';
    deplacerCurseurXY(100 - (Length(txt) div 2), 19); 
    write(txt);
    
    couleurTexte(White);
    txt := 'Veuillez construire l''Ascenseur Orbital (Menu 4 -> 9)';
    deplacerCurseurXY(100 - (Length(txt) div 2), 21);
    write(txt);
    
    attendre(2000); 
    Exit; 
  end;

  // --- 2. MENU DE TRANSPORT ---
  effacerEcran();
  
  // Cadre principal (Largeur 80: 60 à 140)
  dessinerCadreXY(2, 1, 199, 39, double, LightCyan, Black);

  // Titre
  couleurTexte(LightCyan);
  txt := 'SYSTEME DE TRANSPORT ORBITAL';
  deplacerCurseurXY(90 - (Length(txt) div 2), 10); 
  write(txt);

  // Info Zone Actuelle
  couleurTexte(Yellow);
  txt := 'Position actuelle : ' + partie.Zones[partie.IndexZoneActive].Nom;
  deplacerCurseurXY(90 - (Length(txt) div 2), 12);
  write(txt);
  
  couleurTexte(DarkGray);
  deplacerCurseurXY(65, 14); write('--------------------------------------------------');

  couleurTexte(White);
  deplacerCurseurXY(70, 16); writeln('DESTINATIONS DISPONIBLES :');

  // Boucle d'affichage des zones
  for i := 1 to 3 do
  begin
    deplacerCurseurXY(75, 18 + (i-1)*2); // Espacement vertical de 2 lignes
    
    if i = partie.IndexZoneActive then
    begin
      
       couleurTexte(DarkGray);
       write('[X] ', partie.Zones[i].Nom, ' (Actuelle)');
    end
    else
    begin
       // Zones disponibles en vert
       couleurTexte(LightGreen);
       write('[', i, '] Vers ', partie.Zones[i].Nom);
    end;
  end;
  
  couleurTexte(DarkGray);
  deplacerCurseurXY(65, 25); write('--------------------------------------------------');

  couleurTexte(White);
  deplacerCurseurXY(75, 27); write('Votre choix (0 pour annuler) > ');

  try readln(choix); except choix := -1; end;

  // --- 3. TRAITEMENT DU CHOIX ---
  if (choix >= 1) and (choix <= 3) then
  begin
    if choix = partie.IndexZoneActive then
    begin
      deplacerCurseurXY(75, 29);
      couleurTexte(LightRed); write('Erreur : Vous y etes deja !'); 
      attendre(1000);
    end
    else
    begin
      // Animation de transfert
      couleurTexte(LightMagenta);
      deplacerCurseurXY(75, 29); write('Initialisation du transfert...');
      attendre(500);
      
      ancienneZone := partie.IndexZoneActive;
      
      // A. Sauvegarde de l'état actuel (Important !)
      GestionDesEmplacements.SauvegarderZone(ancienneZone);
      
      // B. Changement d'index
      partie.IndexZoneActive := choix;
      
      // C. Chargement de la nouvelle zone
      GestionDesEmplacements.ChargerZone(choix);
      
      attendre(800);
      
      // Message de succès
      deplacerCurseurXY(75, 29); write('                                      '); 
      deplacerCurseurXY(75, 29);
      couleurTexte(LightGreen);
      writeln('Arrivee confirmée sur ', partie.Zones[choix].Nom, '.');
      attendre(1000);
    end;
  end;
end;

end.