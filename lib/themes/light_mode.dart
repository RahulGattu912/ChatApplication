import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
    textTheme:
        TextTheme(titleLarge: GoogleFonts.spaceMono(color: Colors.black54)),
    colorScheme: ColorScheme.light(
        primary: Colors.grey.shade600,
        secondary: Colors.grey.shade300,
        tertiary: Colors.white,
        shadow: Colors.black));
