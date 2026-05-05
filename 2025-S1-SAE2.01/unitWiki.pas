unit unitWiki;

{$mode delphi}{$H+}

interface
  // --- PAGE DE PREMIER NIVEAU --- //
  procedure wiki();

  // --- PAGES DE DEUXIEME NIVEAU --- //
  procedure pageBatiments();

  procedure pageItems();
  
  procedure pageZones();
  
  procedure pageEmplacements();

  // --- PAGES DE TROISIEME NIVEAU --- //
  procedure pageUsines();

  procedure pageMines();

  procedure pageMineraiItems();

  procedure pageFabricItems();

  // --- PAGES DE QUATRIEME NIVEAU --- //
  procedure pageNiveauMine();

  procedure pageRangMine();


implementation
uses
  SysUtils, Classes, GestionEcran, unitWikiIHM;

// ----- ORGANISATION -----
// ---- FIRST PAGE - MENU ---- LEADS TO BATIMENTS, ITEMS, ZONES, EMPLACEMENTS
// --- BATIMENTS - MENU 2 --- LEADS TO USINES, MINES
// -- MINES - MENU 3 -- LEADS TO TYPES_MINES, NIVEAU_MINES, RANK_MINES
// --- ITEMS - MENU 2 --- LEADS TO MINERAIS, FABRIC

// ---------------------------------------- //
// -------- IMPLEMENTATION DU WIKI -------- //
// ---------------------------------------- //
procedure wiki();
var
  choix:Integer;
begin
  // --- Initialisation des variables --- //
  choix := 5;

  // --- AFFICHAGE DE LA PAGE D'ACCUEIL DU WIKI --- //
  while (choix <> 0) AND (choix <> 1) AND (choix <> 2) AND (choix <> 3) AND (choix <> 4) do
  begin
    affichageFirstPage();
    readln(choix);
  end;

  // --- AFFICHAGE D'UNE PAGE SELON LE CHOIX FAIT PRECEDEMMENT --- //
  case choix of
    1: pageBatiments();
    2: pageItems();
    3: pageZones();
    4: pageEmplacements();
  end;
end;
  
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------- //
// ---------- PARTIE BATIMENTS ---------- //
// -------------------------------------- //
procedure pageBatiments();
var
  choix:Integer;
begin
  // --- Initialisation des variables --- //
  choix := 3;
  while (choix <> 0) AND (choix <> 1) AND (choix <> 2) do
  begin
    affichagePageBatiments();
    readln(choix);
  end;

  // --- AFFICHAGE D'UNE PAGE SELON LE CHOIX FAIT PRECEDEMMENT --- //
  case choix of
    1: pageUsines();
    2: pageMines();
  end;
end;

// ------------ SOUS PARTIE USINES ------------ //
procedure pageUsines();
begin
  affichagePageUsines();
  readln;
end;

// ------------ SOUS PARTIE MINES ------------ //
procedure pageMines();
var
  choix:Integer;
begin
  // --- Initialisation des variables --- //
  choix := 4;

  // --- BOUCLE POUR QUE LES BONS NOMBRES SOIENT DONNES --- //
  while (choix <> 0) AND (choix <> 1) AND (choix <> 2) do
  begin
    affichagePageMines();
    readln(choix);
  end;
  
  // --- AFFICHAGE D'UNE PAGE SELON LE CHOIX FAIT PRECEDEMMENT --- //
  case choix of
    1: pageNiveauMine();
    2: pageRangMine();
  end;
end;

// ---------- NIVEAUX DES MINES ---------- //
procedure pageNiveauMine();
begin
  affichagePageNiveauMine();
  readln;
end;

// ---------- RANG DES MINES ---------- //
procedure pageRangMine();
begin
  affichagePageRangMine();
  readln;
end;



///////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------- //
// ------------ PARTIE ITEMS ------------ //
// -------------------------------------- //
procedure pageItems();
var
  choix:Integer;
begin
  // --- Initialisation des variables --- //
  choix := 4;

  // --- BOUCLE POUR QUE LES BONS NOMBRES SOIENT DONNES --- //
  while (choix <> 0) AND (choix <> 1) AND (choix <> 2) do
  begin
    affichagePageItems();
    readln(choix);
  end;
  
  // --- AFFICHAGE D'UNE PAGE SELON LE CHOIX FAIT PRECEDEMMENT --- //
  case choix of
    1: pageMineraiItems();
    2: pageFabricItems();
  end;
end;

// ---------- MINERAI ---------- //
procedure pageMineraiItems();
begin
  affichagePageMinerais();
  readln;
end;

// ---------- FABRIC ---------- //
procedure pageFabricItems();
begin
  affichagePageFabrics();
  readln;
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------- //
// ------------ PARTIE ZONES ------------ //
// -------------------------------------- //
procedure pageZones();
begin
  affichagePageZones();
  readln;
end;


///////////////////////////////////////////////////////////////////////////////////////////////////////////
// ------------------------------------- //
// -------- PARTIE EMPLACEMENTS -------- //
// ------------------------------------- //
procedure pageEmplacements();
begin
  affichagePageEmplacements();
  readln;
end;


end.