import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkMode = ThemeData(
    textTheme:
        TextTheme(titleLarge: GoogleFonts.spaceMono(color: Colors.white54)),
    colorScheme: ColorScheme.dark(
        primary: Colors.grey.shade600,
        secondary: Colors.black,
        tertiary: Colors.black,
        shadow: Colors.white));
