# Courtify – Athlo (Native Flutter Mobile Application)

An immersive, high-performance, native sports booking, coaching, and biomechanics tracking mobile application built entirely with **Flutter & Dart**. This is a **100% native mobile app designed for iOS and Android devices**, utilizing the modern Flutter rendering engines for optimal mobile performance instead of standard web architectures. 

The application empowers athletes, coaches, parents, and club managers through lightweight, high-fidelity mobile-first user interfaces.

## Features

- **Role-Based Access Control & Dashboards:**
  - **Elite Player Workspace:** Real-time mobile sport selection (Tennis, Squash, Padel), Elo ranking updates, personal training telemetry, and interactive skill classification.
  - **Club Coach Hub:** Live telemetry inputs, smart session schedules, and mobile athlete progression logs.
  - **Parent Sync Dashboard:** Secured billing overviews, calendar synchronization, and youth participation logs.
  - **Club Administrator Console:** Dynamic court reservation matrices, operational live-feed tracking, and secure database auditing.

- **Interactive Core Mobile Modules:**
  - **Smart Court Reservation Platform:** Dynamic venue and slot coordinator supporting multiple hard or clay court profiles.
  - **Encrypted Digital Chat Channels:** Live messaging stream between players, coaches, and peers, equipped with native mobile push notifications support.
  - **AI Voice Tele-Coach:** Multi-modal real-time audio guide supporting live biomechanics comments during racket acceleration.
  - **Veo Technique Video Lab:** High-fidelity video rendering capabilities to demonstrate slow-motion top-spin forehand curves directly on mobile screens.
  - **Biometrics Telemetry Charts:** Custom visualization indicators representing Top-Spin Velocity (RPM), Racquet Speed (MPH), and Launch Alignment.

---

## Technical Architecture

This repository contains a **cross-platform native mobile codebase**. It is built from the ground up for native device execution and is **not a web app**:

- **Core Framework:** Flutter 3.x (compiled to native ARM64 / x86 binaries for high iOS and Android scrolling performance).
- **Language:** Safe, statically typed Dart.
- **State Management:** Reactive state models representing real-time local and remote session variables.
- **Cloud Backend Services:** Google Firebase (Authentication, Cloud Firestore, Remote Cloud Storage, and Mobile Push Notifications).
- **Security Protocols:** Role-specific Firestore access control rules guarding athlete data, coaching records, and parent linkages.

---

## Getting Started (Mobile Build & Run)

Follow the guidelines below to compile and execute the native mobile package:

1. **Prerequisites & SDKs:**
   - Install the Flutter SDK matching standard stable parameters.
   - Set up your physical mobile device or virtual emulator (Android Studio Emulator / Apple Xcode iOS Simulator).

2. **Retrieve Dependencies:**
   Navigate to the root directory containing `pubspec.yaml` and fetch the necessary package bindings:
   ```bash
   flutter pub get
   ```

3. **Verify Configuration:**
   - Setup a standard Firebase project via the Firebase Console Web portal.
   - Generate your native platform configuration:
     - `google-services.json` inside `android/app/` for Android execution.
     - `GoogleService-Info.plist` inside `ios/Runner/` for iOS execution.

4. **Launch Application:**
   Run the Flutter executable for your selected mobile target:
   ```bash
   flutter run
   ```

---

## Codebase Directory Structure

The structure under the core Dart workspace (`lib/`) consists of clean, modular entities:

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
