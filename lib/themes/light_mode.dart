import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme theme =
    TextTheme(titleLarge: GoogleFonts.spaceMono(color: Colors.grey.shade600));

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.light(
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade300,
        tertiary: Colors.white,
        shadow: Colors.black));
