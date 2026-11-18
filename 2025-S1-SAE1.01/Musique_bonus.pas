unit Musique_bonus;
//cette unit a été fait par gemini et des recherches internet, pour améliorer l'imersion du jeux merci a eux il s'agit de la seul page d'ailleurs


interface
uses 
  windows;

procedure SonCash();
procedure SonConstruction();
procedure SonUpgrade();
procedure SonTeleportation();
procedure SonErreur();
procedure SonAlarme();
procedure SonGameOver();
procedure SonMission();
procedure SonVictoireSologny();
procedure SonApparitionSologny();
procedure SonSonar();
procedure SonDemarrage();
procedure SonMenuMove();
procedure SonStartGame();
procedure SonNouveauJour();
procedure SonQuitter();
implementation


procedure SonCash();
var i : Integer;
begin
  for i := 1 to 4 do Beep(450 + (i * 150), 25); 
  Beep(1318, 50); Beep(1568, 120); 
end;


procedure SonConstruction();
var i : Integer;
begin

  for i := 1 to 5 do
  begin
    Beep(100 + (i * 30), 20); 
  end;
  Beep(1000, 40); 
  Beep(800, 80);  
end;

procedure SonUpgrade();
begin
  Beep(523, 60);
  Beep(659, 60); 
  Beep(784, 60); 
  Beep(1046, 120); 
end;

procedure SonTeleportation();
var i : Integer;
begin
  for i := 1 to 15 do
  begin
    Beep(200 + (i * i * 3), 30); 
  end;
  Beep(2000, 100); 
end;

procedure SonErreur();
begin
  Beep(300, 100); 
  Beep(200, 150); 
end;

procedure SonAlarme();
var i : Integer;
begin
  for i := 1 to 2 do
  begin
    Beep(880, 100);
    Beep(659, 100);
  end;
end;


procedure SonGameOver();
begin
  Beep(392, 300); // Sol
  Beep(370, 300); // Fa#
  Beep(349, 300); // Fa
  Beep(330, 800); // Mi (Long et triste)
end;

procedure SonMission();
begin
  Beep(523, 100); // Do
  Beep(523, 100); // Do
  Beep(523, 100); // Do
  Beep(659, 300); // Mi
  Sleep(50);
  Beep(523, 100); // Do
  Beep(659, 600); // Mi (Final)
end;

procedure SonVictoireSologny();
begin
  // Rapide montée en puissance
  Beep(523, 100); // Do (C5)
  Beep(659, 100); // Mi (E5)
  Beep(784, 100); // Sol (G5)
  
  // Petite pause dramatique
  Sleep(50);
  
  // Note finale haute et longue (La gloire !)
  Beep(1046, 600); // Do (C6)
  
  // Petit écho de fin (optionnel, pour le style)
  Sleep(100);
  Beep(1046, 150); 
end;

procedure SonApparitionSologny();
begin
  // Trois notes fortes et rythmées (Sol - Sol - Sol)
  Beep(392, 400); Sleep(50);
  Beep(392, 400); Sleep(50);
  Beep(392, 400); Sleep(50);
  
  // La note de tension (Mi bémol grave)
  Beep(311, 350); Sleep(50);
  
  // La remontée (Si bémol)
  Beep(466, 150); Sleep(50);
  
  // La note finale qui tue (Sol)
  Beep(392, 800); 
end;

procedure SonSonar();
var
  i : Integer;
begin
  // 1. Le Balayage (Le scanner parcourt la zone)
  // On joue 8 notes très courtes qui montent rapidement en fréquence
  for i := 1 to 8 do
  begin
    // Monte progressivement de 1000Hz à 2600Hz
    // Durée : 20ms (très rapide pour faire un effet fluide)
    Beep(1000 + (i * 200), 20); 
  end;

  // 2. Le "Lock" (Cible verrouillée / Fin du scan)
  // Une note haute et claire pour dire "Scan terminé"
  Beep(3000, 80); 
end;

procedure SonDemarrage();
begin
  // On joue un accord de Do Majeur mais dans les graves (Octave 3)
  // C'est beaucoup plus rond et chaud à l'oreille.
  
  Beep(131, 120); // Do grave (C3)
  Sleep(30);      // Petite pause pour détacher les notes
  
  Beep(196, 120); // Sol grave (G3)
  Sleep(30);
  
  Beep(262, 120); // Do moyen (C4)
  Sleep(30);
  
  // Note finale : Mi (E4) - Tenue, mais pas perçante
  Beep(330, 600); 
end;
procedure SonStartGame();
begin
  // On reprend là où l'intro s'est arrêtée et on monte l'accord final
  // C'est un mouvement "Do - Mi - Sol - Do" (C4 -> C5)
  // C'est dynamique mais ça reste doux (max 523 Hz)
  
  Beep(262, 80);  // Do moyen (C4)
  Beep(330, 80);  // Mi (E4)
  Beep(392, 80);  // Sol (G4)
  
  // Note finale de validation : Do (C5)
  // Claire, nette, mais pas perçante
  Beep(523, 400); 
end;

procedure SonMenuMove();
begin
  // Cela crée un effet de "clic" électronique propre.
  Beep(1200, 20); 
end;

procedure SonQuitter();
begin
  // Descente rapide (C6 -> G5 -> E5)
  Beep(1046, 80); // Do (Haut)
  Beep(784, 80);  // Sol
  Beep(659, 80);  // Mi
  
  // Petite pause
  Sleep(20);
  
  // Note finale douce (Do bas)
  Beep(523, 400); 
end;
procedure SonNouveauJour();
begin
  Beep(330, 200);  // E4
  Beep(392, 220);  // G4
  Sleep(60);
  
  Beep(523, 250);  // C5 (pas trop aigu)
  Sleep(80);

  Beep(440, 250);  // A4
  Beep(494, 350);  // B4 final
end;
end.