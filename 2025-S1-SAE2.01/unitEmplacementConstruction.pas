unit unitEmplacementConstruction;
{Le role de cette unit est de gerer les emplacements de constructions}

//commentaire pour HUGO ET MARTIUS merci de séparer l'IHM du "code". -battal
interface

  procedure GererEmplacementConstruction();
  procedure ConstruireAscenseurIHM();
implementation

uses
  unitLogic, GestionEcran, SysUtils, unitIHM, unitMission, unitINV, math;

procedure ConstruireAscenseurIHM();
begin
  effacerEcran();
  dessinerCadreXY(2, 1, 199, 39, double, Green, Black);
  couleurTexte(LightGreen);
  deplacerCurseurXY(85, 12);
  writeln('CONSTRUCTION TERMINEE !');
  deplacerCurseurXY(85, 14);
  writeln('L''ascenseur orbital est operationnel.');
  couleurTexte(White);
  attendre(2000);
end;

procedure GererEmplacementConstruction();
var
  choix : Integer;
begin
  effacerEcran();
  dessinerCadreXY(2, 1, 199, 39, double, LightCyan, Black);

  deplacerCurseurXY(85, 12);
  couleurTexte(LightCyan);
  writeln('EMPLACEMENT DE CONSTRUCTION');
  couleurTexte(White);
  deplacerCurseurXY(80, 15);
  // --- REEQUILIBRAGE PRIX ---
  writeln('1. Construire un ascenseur (Cout : 5000 DolarsZANI)');
  // --------------------------

  deplacerCurseurXY(80, 18);
  writeln('0. Retour au menu principal');

  deplacerCurseurXY(80, 23);
  write('Votre choix : ');
  readln(choix); 
  case choix of
    1: begin
         if not partie.ascenseurConstruit then
         begin
           // --- REEQUILIBRAGE PRIX ---
           if partie.DolarsZANI >= 5000 then
           begin
             partie.DolarsZANI := partie.DolarsZANI - 5000;
             partie.ascenseurConstruit := True;
             ConstruireAscenseurIHM();
           end
           // --------------------------
           else
           begin
             couleurTexte(LightRed);
             deplacerCurseurXY(80, 25);
             writeln('Vous n''avez pas assez de DolarsZANI !');
             couleurTexte(White);
             attendre(2000);
           end;
         end
         else
         begin
         effacerEcran();
         dessinerCadreXY(2, 1, 199, 39, double, Red, Black);
           couleurTexte(Red);
           deplacerCurseurXY(78, 20);
           writeln('L''ascenseur est deja construit !');
           couleurTexte(White);
           attendre(2000);
         end;
       end;
    0: ;
  end;
end;

end.