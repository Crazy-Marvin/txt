import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:txt/widget/notched_shapes.dart';

enum AppTheme { Light, Dark, Purple }

class ThemesNotifier with ChangeNotifier {

  static const _defaultTheme = AppTheme.Light;

  AppTheme _theme;
  ThemeData _themeData;
  SystemUiOverlayStyle _systemUiOverlayStyle;

  factory ThemesNotifier() => ThemesNotifier.theme(_defaultTheme);

  ThemesNotifier.theme(AppTheme theme) {
    this.theme = AppTheme.Light;
  }

  get theme => _theme;

  set theme(AppTheme theme) {
    if (theme != null) {
      _theme = theme;
      _themeData = _buildThemeData();
      _systemUiOverlayStyle = _buildAppSystemUiOverlayStyle();

      notifyListeners();
    }
  }

  get themeData => _themeData;

  get systemUiOverlayStyle => _systemUiOverlayStyle;

  ThemeData _buildThemeData() {
    ThemeData baseTheme;
    switch (theme) {
      case AppTheme.Light:
        baseTheme = ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          accentColor: Colors.purple,
        );
        break;
      case AppTheme.Dark:
        baseTheme = ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          bottomAppBarColor: Colors.grey.shade700,
          scaffoldBackgroundColor: Colors.grey.shade800,
          accentColor: Colors.purple,
        );
        break;
      case AppTheme.Purple:
        baseTheme = ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.purple,
            primaryVariant: Colors.purple.shade800,
            secondary: Colors.purpleAccent.shade700,
            secondaryVariant: Colors.purpleAccent.shade700,
            surface: Colors.purple.shade900,
            background: Colors.purple.shade900,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onBackground: Colors.white,
          ),
          bottomAppBarColor: Colors.purple.shade600,
          scaffoldBackgroundColor: Colors.purple.shade900,
          accentColor: Colors.purple,
        );
        break;
    }
    return baseTheme.copyWith(
      textTheme: _buildTextTheme(baseTheme.textTheme),
      floatingActionButtonTheme: baseTheme.floatingActionButtonTheme.copyWith(
          backgroundColor: baseTheme.accentColor
      ),
      bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
        shape: StadiumBorderNotchedRectangle(),
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.workSansTextTheme(base).copyWith(
      headline: GoogleFonts.pacifico(
        textStyle: base.headline,
        fontWeight: FontWeight.w800,
      ),
      button: GoogleFonts.poppins(
        textStyle: base.button,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  SystemUiOverlayStyle _buildAppSystemUiOverlayStyle() {
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
          statusBarColor: Colors.purple.shade900,
          systemNavigationBarColor: Colors.purple.shade600,
          systemNavigationBarIconBrightness: Brightness.light,
        );
        break;
    }
    return overlayStyle;
  }
}
