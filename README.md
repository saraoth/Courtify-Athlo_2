# Courtify – Athlo (Flutter & Dart)

An immersive, high-performance sports booking, coaching, and biomechanics tracking ecosystem built with Flutter & Dart. The application empowers athletes, coaches, parents, and club managers through tailored interfaces and intelligence engines.

## Features

- **Role-Based Access Control & Dashboards:**
  - **Elite Player Workspace:** Real-time sport selection (Tennis, Squash, Padel), Elo ranking updates, personal training telemetry, and interactive skill classification.
  - **Club Coach Hub:** Live telemetry inputs, smart session schedules, and athlete progression logs.
  - **Parent Sync Dashboard:** Secured billing overviews, calendar synchronization, and youth participation logs.
  - **Club Administrator Console:** Dynamic court reservation matrices, operational live-feed tracking, and secure database auditing.

- **Interactive Core Modules:**
  - **Smart Court Reservation Platform:** Dynamic venue and slot coordinator supporting multiple hard or clay court profiles.
  - **Encrypted Digital Chat Channels:** Live messaging stream between players, coaches, and peers, equipped with custom push notifications support.
  - **AI Voice Tele-Coach:** Multi-modal real-time audio guide supporting live biomechanics comments during racket acceleration.
  - **Veo Technique Video Lab:** High-fidelity video rendering capabilities to demonstrate slow-motion top-spin forehand curves.
  - **Biometrics Telemetry Charts:** Custom visualization indicators representing Top-Spin Velocity (RPM), Racquet Speed (MPH), and Launch Alignment.

---

## Technical Architecture

- **Core Framework:** Flutter 3.x representing high-frequency painting performance with CanvasKit.
- **Language:** Safe, statically typed Dart.
- **State Management:** Reactive state models representing real-time local and remote session variables.
- **Cloud Backend Services:** Google Firebase (Authentication, Cloud Firestore, Remote Cloud Storage, and Push Notifications).
- **Security Protocols:** Role-specific Firestore access control rules guarding athlete data, coaching records, and parent linkages.

---

## Getting Started

Follow the guidelines below to compile and execute the Flutter native package:

1. **Prerequisites & SDKs:**
   - Install the Flutter SDK matching standard stable parameters.
   - Set up your physical device or virtual emulator (Android Studio / iOS Simulator).

2. **Retrieve Dependencies:**
   Navigate into the flutter directory and fetch the necessary package bindings:
   ```bash
   cd flutter_app
   flutter pub get
   ```

3. **Verify Configuration:**
   - Setup a standard Firebase project via the Firebase Console Web portal.
   - Generate your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) configuration files, or configure dynamic platform keys.

4. **Launch Application:**
   Run the Flutter executable:
   ```bash
   flutter run
   ```

---

## Codebase Directory Structure

The structure under the core Dart workspace (`flutter_app/lib`) consists of clean, modular entities:

- `lib/main.dart` — App bootstrap layer, theme configuration, and localized routes layout.
- `lib/models/` — Implements profile data schemes, message payloads, and court structures.
- `lib/screens/` — General screen controllers containing:
  - `splash_screen.dart` — Native loading page context.
  - `onboarding_screen.dart` — Custom role calibration slider.
  - `login_screen.dart` — Authentication forms.
  - `dashboard_screen.dart` — Centralized multi-tab controller.
- `lib/screens/dashboards/` — Dedicated workspace files:
  - `player_dashboard.dart`
  - `coach_dashboard.dart`
  - `parent_dashboard.dart`
  - `admin_dashboard.dart`
- `lib/screens/features/` — Interactive utilities:
  - `chat_screen.dart` — Secured chat stream thread views.
  - `booking_screen.dart` — Seat reservation engine.
  - `ai_insights.dart` — Biometrics telemetry gauges.
  - `live_coach_screen.dart` — Voice tele-coaching channel mockups.
  - `video_generator_screen.dart` — Veo frame compiler layout.
