# Satisfact'IUT

> Jeu de gestion industrielle en console, développé en Pascal (Free Pascal / Lazarus) dans le cadre de la SAE 1.01 — IUT Dijon, Département Informatique.

---

## Description

**Satisfact'IUT** est un jeu de gestion inspiré de *Satisfactory*. Le joueur gère une colonie industrielle répartie sur **3 zones planétaires** : Viltrum, Arcadia et Titan. L'objectif est d'explorer les terrains, construire des bâtiments, exploiter des gisements de ressources, honorer des contrats galactiques et développer son empire industriel jour après jour.

---

## Fonctionnalités

### Gestion du temps

- La partie se déroule jour par jour à partir du **01/01/2025**.
- Chaque action coûte **1 heure** de la journée (départ à 8h00).
- Passé **22h00**, le joueur est trop fatigué pour agir ; passé **20h00**, l'exploration est impossible (nuit).
- L'option **Dormir** fait passer au jour suivant et déclenche la production automatique + le bilan journalier.

### Ressources

Le jeu dispose d'une hiérarchie de ressources :

| Ressource            | Usage                                  |
|----------------------|----------------------------------------|
| Bois                 | Matériau de base (construction)        |
| Brique               | Produit par les carrières              |
| Cuivre               | Minerai de base                        |
| Titane               | Alliage léger                          |
| Nétherite            | Blindage                               |
| Palladium            | Catalyseur rare                        |
| Endium               | Source quantique (ressource ultime)    |
| Câble Électrique     | Produit manufacturé                    |
| Bloc de Construction | Produit manufacturé                    |
| PC Gamer             | Produit manufacturé (haut de gamme)    |

### Bâtiments

Chaque zone possède **10 emplacements** constructibles :

- **Mine** — Exploite un gisement de minerai (coût variable selon le minerai)
- **Centrale électrique** — Produit de l'énergie nécessaire au fonctionnement des bâtiments
- **Carrière** — Produit de la Brique
- **Forêt** — Produit du Bois
- **Usine à Câbles** — Produit des Câbles Électriques
- **Usine à Blocs** — Produit des Blocs de Construction
- **Usine à PC** — Produit des PC Gamer

Les bâtiments sont améliorables (niveau 1 → niveaux supérieurs) pour augmenter leur production. Ils peuvent tomber en panne aléatoirement (1% de chance par jour) et nécessitent alors une réparation (100 $).

### Exploration

Le joueur peut explorer les emplacements inconnus de sa zone active pour découvrir des **gisements** (avec un rang de pureté : B, A ou S) ou des **terrains vides** utilisables pour des usines.

### Contrats galactiques (Missions)

Une fois l'**ascenseur orbital** construit, des contrats aléatoires sont générés par l'IUT Dijon. Chaque contrat demande une quantité d'une ressource contre une récompense en DolarsZANI (ZANI$). Il est possible de résilier un contrat moyennant une pénalité de **500 $**.

### Boutique de Bonus

Accessible après construction de l'ascenseur orbital, pour **2 000 $**, le joueur peut activer un bonus pendant **5 jours** :

| Bonus                | Effet                                   |
|----------------------|-----------------------------------------|
| Protocole Industriel | Double la production des mines          |
| Subvention IUT       | Divise les coûts de construction par 2  |
| Supra-Conducteurs    | Double la production des centrales      |

### Marché Galactique

Le joueur peut vendre ses ressources par packs de 10 unités, ou tout vendre d'un coup, contre des DolarsZANI.

### Wiki intégré

Un wiki en jeu documente les ressources, bâtiments et mécaniques pour aider le joueur.

### Menu Admin (code : `99`)

Un menu caché permet de tricher (remplir les stocks, révéler la carte, réparer tous les bâtiments, construire l'ascenseur…). Le jeu affiche alors un badge **TRICHEUR** visible à l'écran.

---

## Structure du projet

```
SatisfactIUT/
├── SatisfactIUT.lpr                # Point d'entrée du programme
├── unitLogic.pas                   # Logique centrale (structures, boucle de jeu, temps)
├── unitIHM.pas                     # Interface homme-machine (menus, écran titre)
├── unitBatiment.pas                # Construction, amélioration, récolte, vente
├── unitMission.pas                 # Contrats galactiques et boutique de bonus
├── unitChangeZone.pas              # Déplacement entre zones
├── unitEmplacementConstruction.pas # Gestion des emplacements
├── GestionDesEmplacements.pas      # Chargement/sauvegarde des zones en mémoire
├── GestionEcran.pas                # Utilitaires d'affichage console (couleurs, cadres, curseur)
├── unitINV.pas                     # Inventaire
├── unitWiki.pas                    # Données du wiki
├── unitWikiIHM.pas                 # Affichage du wiki
├── Musique_bonus.pas               # Sons et effets audio (beep Windows)
└── SatisfactIUT.exe                # Exécutable compilé (Windows)
```

---

## Prérequis & Compilation

- **Compilateur** : [Free Pascal (FPC)](https://www.freepascal.org/) ou [Lazarus IDE](https://www.lazarus-ide.org/)
- **OS cible** : Windows (utilisation de l'unité `windows` pour les sons et la console)
- **Mode** : `{$mode delphi}` / `{$mode objfpc}`

Pour compiler :
```bash
fpc SatisfactIUT.lpr
```

Ou ouvrir le projet dans **Lazarus** et lancer la compilation depuis l'IDE.

---

## Lancement

```bash
SatisfactIUT.exe
```

> Le jeu est conçu pour une console Windows en **plein écran** ou avec une largeur d'au moins **200 colonnes** pour un affichage optimal.

---

## Équipe

Projet réalisé par **LOCUFIER Marius, BANDERIER Hugo, ARMAND Antoine, SAHIN Battal** — IUT Dijon, Département Informatique, SAE 1.01 (2025, Semestre 1).
