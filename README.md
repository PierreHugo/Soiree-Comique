# 🎉 Soirée Comique

Une application iOS fun, minimaliste et immersive pour animer vos
soirées entre amis.

------------------------------------------------------------------------

## ✨ Features

### 👆 Chooser (sélecteur multi‑joueurs)

-   Jusqu'à 5 joueurs simultanément
-   Détection multi‑touch en temps réel
-   Sélection aléatoire après stabilité
-   Animation immersive + vibrations

### 🎡 Roues personnalisables

-   Trois roues indépendantes
-   Édition libre des options (ajout / suppression / modification)
-   Réinitialisation rapide aux valeurs par défaut
-   Animation fluide avec haptics
-   Résultat déterminé visuellement sous la flèche

### 🙋‍♂️ Questions 

-   Mode "Pointe du doigt" : les joueurs votent pour la personne qui correspond le plus à une situation donnée
-   Mode "Je n'ai jamais" : les joueurs qui ont déjà fait une situation donnée sont désignés
-   Mode "Action ou shot" : un joueur doit faire face à une situation imposée ou il prend un gage (4 niveaux de difficultés)

### 🎨 Thèmes

-   Mode clair / sombre
-   Thème global configurable depuis les réglages

------------------------------------------------------------------------

## 🛠 Architecture

Projet structuré en SwiftUI moderne :

Presentation/ Wheel/ Chooser/ Settings/ Domain/ Models/ Core/ Theme/

-   `WheelViewModel` gère la logique métier des roues
-   `ThemeManager` centralise la gestion des thèmes
-   UI entièrement SwiftUI
-   Aucune dépendance externe

------------------------------------------------------------------------

## 🚀 Installation

1.  Ouvrir le projet dans la dernière version de Xcode
2.  Sélectionner un simulateur ou device
3.  Build & Run

------------------------------------------------------------------------

## 📱 Compatibilité

-   iOS 17+
-   Swift 5.9+
-   Xcode 15+

------------------------------------------------------------------------

## 📦 Roadmap

-   Davantages de langages disponibles
-   Davantages de modes de jeux dans la section "questions"

------------------------------------------------------------------------

## 👨‍💻 Auteur

Made by **PierreHugo**

------------------------------------------------------------------------

## 📄 Licence

Distribué sous licence MIT. Voir le fichier `LICENSE`.
