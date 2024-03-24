import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static const _lightFillColor = Color(0xFFB71540);
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  // TODO: this will be refactored once we have the dark theme schema from design
  // static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static ThemeData darkThemeData =
      themeData(lightColorScheme, _lightFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      fontFamily: GoogleFonts.nunito().fontFamily,
      colorScheme: colorScheme,
      textTheme: _textTheme,

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.background,
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: _textTheme.titleLarge!.apply(color: Colors.black),
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colorScheme.background,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.background,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onPrimary,
      ),
      iconTheme: IconThemeData(color: colorScheme.background),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.titleMedium!.apply(color: _darkFillColor),
      ),
    );
  }

  static ColorScheme lightColorScheme = const ColorScheme(
    primary: Color.fromARGB(255, 74, 105, 189),
    primaryContainer: Color(0xFF82CCDD),
    secondary: Color.fromARGB(255, 106, 168, 79),
    secondaryContainer: Color(0xFFEB4A4A),
    tertiary: Color(0xFF6320EE), // wrong code
    tertiaryContainer: Color(0xFFF0FBE7),
    background: Colors.white,
    onSurfaceVariant: Color(0xFFF5F5F5),
    surface: Color(0xFFF3F4F6),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: Color.fromARGB(255, 196, 196, 196),
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFFF0F0F0),
    brightness: Brightness.light,
  );

  // 4EA8DE picton blue
  // 80FFDB aquamarine

  static ColorScheme darkColorScheme = const ColorScheme(
    primary: Color(0xFFFF8383),
    primaryContainer: Color(0xFF1CDEC9),
    secondary: Color(0xFF80FFDB),
    secondaryContainer: Color(0xFF451B6F),
    background: Colors.black,
    surface: Color(0xFF1F1929),
    onBackground: Color(0xFFC4C4C4),
    // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: Color(0xFFC4C4C4),
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headlineMedium: GoogleFonts.nunito(fontWeight: _bold, fontSize: 20.0),
    bodySmall: GoogleFonts.nunito(fontWeight: _semiBold, fontSize: 16.0),
    headlineSmall: GoogleFonts.nunito(fontWeight: _medium, fontSize: 16.0),
    titleMedium: GoogleFonts.nunito(fontWeight: _medium, fontSize: 18.0),
    labelSmall: GoogleFonts.nunito(fontWeight: _medium, fontSize: 12.0),
    bodyLarge: GoogleFonts.nunito(fontWeight: _regular, fontSize: 14.0),
    titleSmall: GoogleFonts.nunito(fontWeight: _medium, fontSize: 14.0),
    bodyMedium: GoogleFonts.nunito(fontWeight: _regular, fontSize: 16.0),
    titleLarge: GoogleFonts.nunito(fontWeight: _bold, fontSize: 20.0),
    labelLarge: GoogleFonts.nunito(fontWeight: _semiBold, fontSize: 14.0),
  );
}