# Projet_Flutter_Garage_Management

Voici une application Flutter de Gestion pour un garage cross-platform IOS / Android.

Inclus : 

- Gestion voitures
- Gestion clients
- Gestion employés

## Getting Started

Téléchargez l'ensembles des fichiers et Builder directement avec Android studio ou l'IDE de votre choix.

## Getting started & Structure du Projet

```shell
---------------------------------------

projet_garage_management_flutter/
│
├── .dart_tool/
├── .idea/
├── android/
├── assets/
│   ├── fonts/
│   └── icon/
│       └── app_icon.png
│
├── build/
├── ios/
├── lib/
│   ├── database/
│   │   └── db_helper.dart
│   │
│   ├── models/
│   │   ├── car.dart
│   │   ├── client.dart
│   │   ├── employe.dart
│   │   └── maintenance.dart
│   │
│   ├── screens/
│   │   ├── add_car_page.dart
│   │   ├── add_client_page.dart
│   │   ├── add_employee_page.dart
│   │   ├── car_list_page.dart
│   │   ├── client_cars_page.dart
│   │   ├── client_list_page.dart
│   │   ├── edit_client_page.dart
│   │   ├── edit_employee_page.dart
│   │   ├── employee_list_page.dart
│   │   └── home_page.dart
│   │
│   ├── services/
│   │   └── firebase_sync_service.dart
│   │
│   └── main.dart
│
├── test/
│
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── analysis_options.yaml
├── projet_flutter_app.iml
├── pubspec.lock
├── pubspec.yaml
└── README.md
