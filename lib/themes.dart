import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txt/widget/notched_shapes.dart';

enum AppColorScheme { Auto, Light, Dark, Purple }

ThemeData getThemeData(AppColorScheme theme, BuildContext context) {
  return getBrightnessBasedThemeData(theme).getByContext(context);
}

BrightnessBased<ThemeData> getBrightnessBasedThemeData(AppColorScheme theme) {
  if (theme == AppColorScheme.Auto) {
    // Delegate to light and dark theme.
    return BrightnessBased(
          () => getBrightnessBasedThemeData(AppColorScheme.Light).light,
          () => getBrightnessBasedThemeData(AppColorScheme.Dark).dark,
    );
  }

  ColorScheme colorScheme;
  switch (theme) {
    case AppColorScheme.Light:
      colorScheme = ColorScheme.light(
        primary: Colors.white,
        primaryVariant: Colors.grey.shade100,
        secondary: Colors.purple.shade400,
        secondaryVariant: Colors.purpleAccent.shade400,
        surface: Colors.white,
        background: Colors.white,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
      );
      break;
    case AppColorScheme.Dark:
      colorScheme = ColorScheme.dark(
        primary: Colors.grey.shade800,
        primaryVariant: Colors.grey.shade800,
        secondary: Colors.purple.shade400,
        secondaryVariant: Colors.purpleAccent.shade700,
        surface: Colors.grey.shade800,
        background: Colors.grey.shade900,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      );
      break;
    case AppColorScheme.Purple:
      colorScheme = ColorScheme.dark(
        primary: Color(0xFF6D0081),
        primaryVariant: Color(0xFF6D0081),
        secondary: Color(0xFFAC11B7),
        secondaryVariant: Color(0xFF6D0081),
        surface: Color(0xFF6D0081),
        background: Color(0xFF35023E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      );
      break;
    case AppColorScheme.Auto:
      throw StateError("Auto theme is delegate to light and dark theme.");
  }
  var baseTheme = ThemeData.from(colorScheme: colorScheme).copyWith(
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme.copyWith(
        primary: colorScheme.secondary,
        primaryVariant: colorScheme.secondaryVariant,
      ),
      textTheme: ButtonTextTheme.primary,
    ),
  );
  return baseTheme
      .copyWith(
    textTheme: baseTheme.textTheme.withAppFonts(),
    primaryTextTheme: baseTheme.primaryTextTheme.withAppFonts(),
    accentTextTheme: baseTheme.accentTextTheme.withAppFonts(),
    bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
      shape: StadiumBorderNotchedRectangle(),
      color: colorScheme.primary,
    ),
    bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      backgroundColor: colorScheme.surface,
    ),
      cardTheme: baseTheme.cardTheme.copyWith(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      )
  )
      .asBrightnessBased();
}

extension AppFontsTextTheme on TextTheme {
  TextTheme withAppFonts() {
    return GoogleFonts.workSansTextTheme(
      this,
    ).copyWith(
      title: GoogleFonts.poppins(
        textStyle: title,
        fontWeight: FontWeight.w800,
      ),
      button: GoogleFonts.poppins(
        textStyle: button,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

@immutable
class BrightnessBased<T> {
  final T Function() _light;
  final T Function() _dark;

  T get light => _light();

  T get dark => _dark();

  T get(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return dark;
      case Brightness.light:
        return light;
    }
    throw ArgumentError("Parameter brightness must be one "
        "of Brightness.dark or Brightness.light.");
  }

  T getByContext(BuildContext context) {
    return get(MediaQuery
        .of(context)
        .platformBrightness);
  }

  BrightnessBased(this._light, this._dark);

  factory BrightnessBased.values(T light, T dark) {
    return BrightnessBased(() => light, () => dark);
  }

  factory BrightnessBased.same(T Function() value) {
    return BrightnessBased(value, value);
  }

  factory BrightnessBased.sameValue(T value) {
    return BrightnessBased.values(value, value);
  }
}

extension MaterialColorExtension on MaterialColor {
  List<Color> get shades {
    return [
      shade50,
      shade100,
      shade200,
      shade300,
      shade400,
      shade500,
      shade600,
      shade700,
      shade800,
      shade900,
    ];
  }

  Color lighterShade(Color color) {
    List<Color> shades = this.shades;
    int index = shades.indexOf(color);
    if (index < 0) {
      throw ArgumentError("The color is not from this material color swatch.");
    } else if (index > 0) {
      return shades[index - 1];
    } else {
      return null;
    }
  }

  Color darkerShade(Color color) {
    List<Color> shades = this.shades;
    int index = shades.indexOf(color);
    if (index < 0) {
      throw ArgumentError("The color is not from this material color swatch.");
    } else if (index < shades.length - 1) {
      return shades[index + 1];
    } else {
      return null;
    }
  }
}

extension ColorExtension on Color {
  MaterialColor get material {
    List<MaterialColor> primaries = List.of(Colors.primaries);
    primaries.add(Colors.grey);
    return primaries.firstWhere((MaterialColor material) {
      return material.shades.any((Color shade) => shade == this);
    }, orElse: () => null);
  }

  Color darken(double amount) {
    assert(amount >= -1 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0, 1));
    return hslDark.toColor();
  }

  Color lighten(double amount) {
    return darken(-amount);
  }

  Color systemUiColor(SystemUiOverlayTheme theme) {
    switch (theme) {
      case SystemUiOverlayTheme.Same:
        return this;
      case SystemUiOverlayTheme.Lighten:
        if (this == Colors.black) return Colors.grey.shade900;
        if (this == Colors.transparent) return Colors.white12;
        return material?.lighterShade(this) ?? lighten(0.03);
      case SystemUiOverlayTheme.Darken:
        if (this == Colors.white) return Colors.grey.shade100;
        if (this == Colors.transparent) return Colors.black12;
        return material?.darkerShade(this) ?? darken(0.03);
      default:
        throw StateError("Unknown system UI overlay theme");
    }
  }
}

enum SystemUiOverlayTheme { Same, Lighten, Darken }

extension ThemeDataExtension on ThemeData {
  BrightnessBased<ThemeData> asBrightnessBased() =>
      BrightnessBased.sameValue(this);

  SystemUiOverlayStyle systemUiOverlayStyle({
    bool hasTopAppBar = true,
    bool hasBottomAppBar = false,
    SystemUiOverlayTheme statusBarTheme = SystemUiOverlayTheme.Darken,
    SystemUiOverlayTheme navigationBarTheme = SystemUiOverlayTheme.Darken,
  }) {
    Brightness iconBrightness =
    brightness == Brightness.light ? Brightness.dark : Brightness.light;

    Color statusBarBaseColor;
    if (hasTopAppBar) {
      statusBarBaseColor = appBarTheme.color ?? primaryColor;
    } else {
      statusBarBaseColor = scaffoldBackgroundColor;
    }

    Color navigationBarBaseColor;
    if (hasBottomAppBar) {
      navigationBarBaseColor = bottomAppBarTheme.color ?? bottomAppBarColor;
    } else {
      navigationBarBaseColor = scaffoldBackgroundColor;
    }

    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: statusBarBaseColor.systemUiColor(statusBarTheme),
      statusBarIconBrightness: iconBrightness,
      statusBarBrightness: brightness,
      systemNavigationBarColor:
      navigationBarBaseColor.systemUiColor(navigationBarTheme),
      systemNavigationBarIconBrightness: iconBrightness,
    );
    return style;
  }

  ThemeData withTranslucentAppBar() {
    AppBarTheme appBarTheme = this.appBarTheme ?? AppBarTheme();
    return copyWith(
      appBarTheme: appBarTheme.copyWith(
        brightness: brightness,
        color: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

class ThemesNotifier with ChangeNotifier {
  static const AppColorScheme _defaultTheme = AppColorScheme.Auto;
  static const String _preferencesKey = "app_theme";

  AppColorScheme _theme;

  factory ThemesNotifier() => ThemesNotifier.theme(_defaultTheme);

  ThemesNotifier.theme(AppColorScheme theme) {
    this.theme = theme;
  }

  static Future<ThemesNotifier> fromPreferences() async {
    return ThemesNotifier.theme(await _getThemePreference());
  }

  AppColorScheme get theme => _theme;

  set theme(AppColorScheme theme) {
    if (theme != null) {
      _theme = theme;
      _setThemePreference(theme);
      notifyListeners();
    }
  }

  static Future<AppColorScheme> _getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_preferencesKey)) return _defaultTheme;
    return AppColorScheme.values[prefs.getInt(_preferencesKey)];
  }

  static Future<bool> _setThemePreference(AppColorScheme theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_preferencesKey, AppColorScheme.values.indexOf(theme));
  }

  BrightnessBased<ThemeData> get themeData =>
      getBrightnessBasedThemeData(theme);
}
