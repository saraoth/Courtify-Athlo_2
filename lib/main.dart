import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'models/user_profile.dart';
import 'models/theme_provider.dart';
import 'models/security_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/features/biometric_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // Configure Firestore persistence for reliable offline operation during field sessions.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firebase initialization caught in fallback: $e');
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SecurityProvider()),
      ],
      child: const CourtifyApp(),
    ),
  );
}

class CourtifyApp extends StatelessWidget {
  const CourtifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Courtify – Athlo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainRouter(),
    );
  }
}

class MainRouter extends StatefulWidget {
  const MainRouter({Key? key}) : super(key: key);

  @override
  State<MainRouter> createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  bool _loading = true;
  UserProfile? _profile;

  void _onInitializationComplete() {
    setState(() {
      _loading = false;
    });
  }

  void _onLoginSuccess(UserProfile profile) {
    setState(() {
      _profile = profile;
    });
  }

  void _onOnboardingComplete(UserProfile updatedProfile) {
    setState(() {
      _profile = updatedProfile;
    });
  }

  void _onLogout() {
    setState(() {
      _profile = null;
    });
  }

  void _onProfileUpdate(UserProfile updatedProfile) {
    setState(() {
      _profile = updatedProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final securityProvider = Provider.of<SecurityProvider>(context);
    if (securityProvider.isCurrentlyLocked) {
      return const BiometricGate();
    }

    if (_loading) {
      return SplashScreen(
        onInitializationComplete: _onInitializationComplete,
      );
    }

    if (_profile == null) {
      return LoginScreen(
        onLoginSuccess: _onLoginSuccess,
      );
    }

    if (!_profile!.onboardingCompleted) {
      return OnboardingScreen(
        profile: _profile!,
        onComplete: _onOnboardingComplete,
      );
    }

    return DashboardScreen(
      profile: _profile!,
      onLogout: _onLogout,
      onProfileUpdate: _onProfileUpdate,
    );
  }
}
