import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*

  NOTE
  Convert these to local where possible. 
  This is being used for placeholders for quicker dev.

  USEFUL
  TextTheme class: https://api.flutter.dev/flutter/material/TextTheme-class.html

*/


// Some colour scheme stuff that I haven't put in the ThemeData object
const LinearGradient highlightGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    // colors: [Color(0xFF0861A8), Color(0xFF4C9DD8), Color(0xFF82F0FF)] 
    colors: [Color(0xFF82F0FF), Color(0xFF4C9DD8), Color(0xFF0861A8)] 
    // colors: [Color(0xFFCB0909), Color(0xFFF6AE2D), Color(0xFFF26419), Color(0xFF480249)]
);


// GENERAL LAYOUT THEMEING ...

const double horizontalInset = 20;


// TEXT THEMES ...

// https://api.flutter.dev/flutter/material/TextTheme-class.html
// Using GoogleFonts.montserratTextTheme() has issues when overriding weight

// General config
const double _displayMediumFonstSize = 24.0;
const double _titleSmallFontSize = 8.0;

// Dark
final TextTheme _textThemeDark = TextTheme(

  // Used for AppBar title
  displayMedium: GoogleFonts.montserrat(
    textStyle: const TextStyle(
      color: Color.fromARGB(255, 250, 250, 250),
      fontSize: _displayMediumFonstSize,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal
    )
  ),
  
  displaySmall: null,

  headlineLarge: null,
  headlineMedium: null,
  headlineSmall: null,

  titleLarge: null,
  titleMedium: null,

  // Used for square button title text on home page
  titleSmall: GoogleFonts.montserrat(
    textStyle: const TextStyle(
      fontSize: _titleSmallFontSize,
      fontWeight: FontWeight.w800,
      fontStyle: FontStyle.normal
    )
  ),

  labelLarge: null,
  labelMedium: null,
  labelSmall: null,

  bodyLarge: null,
  bodyMedium: null,
  bodySmall: null,

);


// COLOUR THEMES ...

// Dark
const _colorSchemeDark = ColorScheme(

  brightness: Brightness.dark,

  // Backcompatability
  background: Color.fromARGB(255, 23, 23, 23),
  onBackground: Color.fromARGB(255, 250, 250, 250),

  // Main background and stuff
  primary: Color.fromARGB(255, 23, 23, 23),
  onPrimary: Color.fromARGB(255, 250, 250, 250),
  
  secondary: Color(0xFFFF00FF), // TBD
  onSecondary: Color(0xFFFF00FF), // TBD
  
  // Used for bottom app bar highlights
  tertiary: Color.fromARGB(255, 250, 250, 250), // Default
  onTertiary: Color.fromARGB(255, 130, 240, 255), // Selected

  // Used for skeleton loader placeholders
  tertiaryContainer: Color.fromARGB(255, 135, 135, 135), // Container background colour
  onTertiaryContainer: Color.fromARGB(255, 192, 192, 192), // Loading highlight colour

  // Buttons on background
  surface: Color.fromARGB(255, 70, 70, 70),
  onSurface: Color.fromARGB(255, 174, 219, 255),
  
  // Error colours
  error: Color(0xFFFF0000),
  onError: Color.fromARGB(255, 0, 0, 255),

);


// MAIN THEME OBJECT ...

// Encapsulates light and dark themes

class AppTheme {

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _colorSchemeDark, // Dark theme is not currently implemented properly
    textTheme: _textThemeDark, // Dark theme is not currently implemented properly
  );

}
