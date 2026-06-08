import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }

  // Common styles
  static final Color primaryBlue = const Color(0xFF2F80ED);
  static final Color successGreen = const Color(0xFF10B981);
  static final Color warnOrange = const Color(0xFFF2994A);

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  // Dark Theme configuration
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      cardColor: const Color(0xFF1E293B),
      canvasColor: const Color(0xFF0B0F19),
      dividerColor: Colors.white10,
      iconTheme: const IconThemeData(color: Colors.white70),
      colorScheme: ColorScheme.dark(
        primary: primaryBlue,
        secondary: successGreen,
        background: const Color(0xFF0F172A),
        surface: const Color(0xFF1E293B),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }

  // Light Theme configuration
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: const Color(0xFFFFFFFF),
      canvasColor: const Color(0xFFF1F5F9),
      dividerColor: Colors.black.withOpacity(0.08),
      iconTheme: const IconThemeData(color: Color(0xFF334155)),
      colorScheme: ColorScheme.light(
        primary: primaryBlue,
        secondary: successGreen,
        background: const Color(0xFFF8FAFC),
        surface: const Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: const Color(0xFF0F172A),
        onSurface: const Color(0xFF0F172A),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }
}
