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
          bottomAppBarColor: Colors.purple.shade600,
          scaffoldBackgroundColor: Colors.purple.shade900,
          accentColor: Colors.purple,
        );
        break;
    }
    return baseTheme.copyWith(
        textTheme: GoogleFonts.workSansTextTheme(
          baseTheme.textTheme,
        ).copyWith(
          title: GoogleFonts.poppins(
            textStyle: baseTheme.textTheme.title,
            fontWeight: FontWeight.w800,
          ),
          button: GoogleFonts.poppins(
            textStyle: baseTheme.textTheme.button,
            fontWeight: FontWeight.bold,
          ),
        ),
        accentTextTheme: GoogleFonts.workSansTextTheme(
          baseTheme.accentTextTheme,
        ).copyWith(
          button: GoogleFonts.poppins(
            textStyle: baseTheme.accentTextTheme.button,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
          shape: StadiumBorderNotchedRectangle(),
        ),
        bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
        ));
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
