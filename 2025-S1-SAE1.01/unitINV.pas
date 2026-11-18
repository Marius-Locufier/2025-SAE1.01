unit unitINV;
{$mode delphi}{$H+}

interface
  procedure AfficherInventaireZone();

implementation

uses
  unitLogic, GestionEcran, SysUtils, unitIHM, math, unitChangeZone;

// Affichage de l'inventaire de la ZONE ACTIVE
procedure AfficherInventaireZone();
var
  idZone : Integer;
  invActuel : TRessource;
  txt : String;
begin
  idZone := partie.IndexZoneActive;
  invActuel := partie.Zones[idZone].Inventaire;

 
  dessinerCadreXY(2, 1, 199, 39, double, White, Black);
  
 
  couleurTexte(LightCyan);
  txt := 'INVENTAIRE - ZONE : ' + partie.Zones[idZone].Nom;
  deplacerCurseurXY(100 - (Length(txt) div 2), 5); 
  write(txt);
  couleurTexte(White);


  deplacerCurseurXY(15, 10); 
  write('Bois: ', invActuel.Bois, '   ');
  write('Brique: ', invActuel.Brique, '   ');
  write('Cuivre: ', invActuel.Cuivre, '   ');
  write('Titane: ', invActuel.Titane, '   ');
  write('Netherite: ', invActuel.Netherite, '   ');
  write('Palladium: ', invActuel.Paladium, '   '); 
  write('Endium: ', invActuel.Endium);


  deplacerCurseurXY(15, 12); 
  write('--------------------------------------------------------------------------------------------------------------------------------------');


  deplacerCurseurXY(15, 14);
  write('Cables: ', invActuel.CableElec, '   ');
  write('Blocs: ', invActuel.BlockConst, '   ');
  write('PC Gamers: ', invActuel.PCGamer, '   ');
  
  write(' |   ');

  couleurTexte(LightGreen);
  write('Energie: ', partie.Energie, '   ');
  
  couleurTexte(Yellow);
  write('DolarsZANI: ', partie.DolarsZANI);
  
 
  couleurTexte(LightGray);
  txt := 'Appuyez sur Entree pour fermer...';
  deplacerCurseurXY(100 - (Length(txt) div 2), 30);
  write(txt);

  readln;
end;

end.