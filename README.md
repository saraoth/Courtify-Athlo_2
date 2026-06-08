# Courtify – Athlo (React)

This is the React version of the Courtify – Athlo application, featuring a complete Firebase backend integration.

## Features
- **Role-Based Access:** Player, Coach, Parent, and Admin dashboards.
- **Booking System:** Real-time court booking with Firestore.
- **Matchmaking:** AI-powered matchmaking based on skill level and sport.
- **Chat System:** Real-time messaging with push notifications.
- **Training Sessions:** Coach-led sessions with attendance tracking.
- **Performance Tracking:** Historical data visualization and AI analysis.

## Tech Stack
- **Frontend:** React (TypeScript)
- **Styling:** Tailwind CSS
- **Animations:** Motion
- **Backend:** Firebase (Auth, Firestore, Storage)

## Getting Started

1.  **Install Dependencies:**
    ```bash
    npm install
    ```
2.  **Firebase Setup:**
    -   The app is pre-configured with Firebase.
    -   The `firebase-applet-config.json` contains the necessary configuration.
    -   Firestore rules are located in `firestore.rules`.
3.  **Run the App:**
    ```bash
    npm run dev
    ```

## Project Structure
- `src/components/`: Reusable UI components and role-specific dashboards.
- `src/features/`: Main application features (Booking, Chat, Performance, Profile).
- `src/firebase.ts`: Firebase initialization and configuration.
- `firestore.rules`: Security rules for Firestore.
- `firebase-blueprint.json`: Database structure definition.

## Security Rules
- Users can only access their own data.
- Coaches can access their assigned players' data.
- Parents can access their children's data.
- Admins have full access to the system.
