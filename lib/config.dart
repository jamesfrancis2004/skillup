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


// TEXT THEMES ...

// https://api.flutter.dev/flutter/material/TextTheme-class.html
// Using GoogleFonts.montserratTextTheme() has issues when overriding weight

// General config
const double _displayLargeFontSize = 32.0;
const double _displayMediumFonstSize = 24.0;
const double _titleSmallFontSize = 8.0;

// Light
final TextTheme _textThemeLight = TextTheme(

  // Used for AppBar title
  displayMedium: GoogleFonts.montserrat(
    textStyle: const TextStyle(
      color: Color.fromARGB(255, 27, 37, 56),
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

// Light
const _colorSchemeLight = ColorScheme(
  
  brightness: Brightness.light,
  
  // Screen background colours
  background: Color.fromARGB(255, 245, 245, 245),
  onBackground: Color.fromARGB(255, 27, 37, 56),

  primary: Color(0xFFFF00FF), // TBD
  onPrimary: Color(0xFFFF00FF), // TBD
  
  secondary: Color(0xFFFF00FF), // TBD
  onSecondary: Color(0xFFFF00FF), // TBD
  
  // Used for bottom app bar highlights
  tertiary: Color.fromARGB(255, 27, 37, 56), // Default
  onTertiary: Color.fromARGB(255, 8, 97, 168), // Selected

  // Used for skeleton loader placeholders
  tertiaryContainer: Color.fromARGB(255, 164, 164, 164), // Container background colour
  onTertiaryContainer: Color.fromARGB(255, 192, 192, 192), // Loading highlight colour

  // Buttons on background
  surface: Color.fromARGB(255, 225, 225, 225),
  onSurface: Color.fromARGB(255, 30, 39, 56),
  
  error: Color(0xFFFF0000),
  onError: Color.fromARGB(255, 0, 0, 255),

);


// Dark
const _colorSchemeDark = ColorScheme(
  
  brightness: Brightness.dark,
  
  // Screen background colours
  background: Color.fromARGB(255, 23, 23, 23),
  onBackground: Color.fromARGB(255, 250, 250, 250),

  primary: Color(0xFFFF00FF), // TBD
  onPrimary: Color(0xFFFF00FF), // TBD
  
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
  //[Color(0xFF82F0FF), Color(0xFF4C9DD8), Color(0xFF0861A8)] 
  
  error: Color(0xFFFF0000),
  onError: Color.fromARGB(255, 0, 0, 255),

);


// MAIN THEME OBJECT ...

// Encapsulates light and dark themes

class AppTheme {

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _colorSchemeLight,
    textTheme: _textThemeLight,
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _colorSchemeDark, // Dark theme is not currently implemented properly
    textTheme: _textThemeLight, // Dark theme is not currently implemented properly
  );

}
