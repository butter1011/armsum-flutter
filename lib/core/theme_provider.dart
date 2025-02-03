import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  final _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.black,
    primaryColor: Colors.black,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.libreBaskerville(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: const TextStyle(color: Colors.black87, fontSize: 20),
      bodySmall: const TextStyle(color: Colors.black, fontSize: 16),
    ),
    cardColor: Colors.white,
  );

  final _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    dividerColor: const Color(0xff1e2937),
    primaryColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.libreBaskerville(
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: const TextStyle(color: Colors.white, fontSize: 20),
      bodySmall: const TextStyle(color: Colors.white, fontSize: 16),
    ),
    cardColor: const Color(0xff1e2937),
  );
}
