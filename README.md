# cafmet

**cafmet** is a Flutter mobile application designed for managing the CAFMet conference. The app provides attendees and organizers with an intuitive way to consult the event program, manage participants, and access detailed conference information.

## 📦 Project Overview

This project follows a **modular architecture** that promotes scalability and maintainability by clearly separating concerns across different layers:

- **Entry Point:**  
  The app starts in `main.dart`, which initializes essential services such as a Google Sheets API integration before launching the main UI. The default landing screen is an onboarding experience to guide new users.

- **Core Logic (`core/`):**  
  Contains app-wide constants, theming, and crucial services including authentication, Google Sheets data handling, and program management.

- **Data Layer (`data/`):**  
  Structured with models and providers, facilitating state management and organized data operations.

- **UI Layer (`ui/`):**  
  Divided into:
  - **Screens:** Key pages like home, login, scan, map, notifications, onboarding, and detailed view screens.
  - **Widgets:** Reusable UI components such as custom buttons, calendar widgets, maps, business info cards, dialogs, and PDF viewers.

## 🚀 Features

- User Authentication  
- Onboarding Flow  
- QR Code Scanning  
- Interactive Maps  
- Notifications System  
- Detailed Business and Event Information Viewing  
- Synchronization and data management via Google Sheets backend

---

## 🇫🇷 Description en français

Développement d'une application mobile pour la gestion de la conférence CAFMet.  
L'application permet de consulter le programme de l'événement, de gérer les participants, et d’accéder aux détails des conférences.

---

This project is designed to be flexible and extensible, making it ideal for event, business, or conference management use cases where data is managed via Google Sheets.
