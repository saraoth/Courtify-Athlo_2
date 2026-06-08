import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import 'models/user_profile.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const CourtifyApp());
}

class CourtifyApp extends StatelessWidget {
  const CourtifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courtify – Athlo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF2F80ED),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
