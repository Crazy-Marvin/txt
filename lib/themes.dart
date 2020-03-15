import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:txt/widget/notched_shapes.dart';

enum AppTheme { Light, Dark, Purple }

SystemUiOverlayStyle buildAppSystemUiOverlayStyle(AppTheme theme) {
  SystemUiOverlayStyle overlayStyle;
  switch (theme) {
    case AppTheme.Light:
      overlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
      break;
    case AppTheme.Dark:
      overlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.grey.shade900,
        systemNavigationBarColor: Colors.grey.shade700,
        systemNavigationBarIconBrightness: Brightness.light,
      );
      break;
    case AppTheme.Purple:
      overlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.purple.shade800,
        systemNavigationBarColor: Colors.purple,
        systemNavigationBarIconBrightness: Brightness.light,
      );
      break;
  }
  return overlayStyle;
}

ThemeData buildAppTheme(BuildContext context, AppTheme theme) {
  ThemeData baseTheme;
  switch (theme) {
    case AppTheme.Light:
      baseTheme = ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        appBarTheme: ThemeData.light().appBarTheme,
      );
      break;
    case AppTheme.Dark:
      baseTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey.shade700,
        bottomAppBarColor: Colors.grey.shade700,
        scaffoldBackgroundColor: Colors.grey.shade800,
      );
      break;
    case AppTheme.Purple:
      baseTheme = ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        bottomAppBarColor: Colors.purple,
        scaffoldBackgroundColor: Colors.purple.shade900,
      );
      break;
  }
  return baseTheme.copyWith(
    accentColor: Colors.purple,
    bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
      shape: RoundedBorderNotchedRectangle(),
    ),
    textTheme: _buildTextTheme(baseTheme.textTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return GoogleFonts.workSansTextTheme(base).copyWith(
    headline: GoogleFonts.poppins(
      textStyle: base.headline,
      fontWeight: FontWeight.w800,
    ),
    button: GoogleFonts.poppins(
      textStyle: base.button,
      fontWeight: FontWeight.bold,
    ),
  );
}
