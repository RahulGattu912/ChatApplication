import 'package:chat_app_demo/themes/dark_mode.dart';
import 'package:chat_app_demo/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  void toggleTheme() {
    if (themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }

  bool get isDarkMode => _themeData == darkMode;
}
