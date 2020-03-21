import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:txt/widget/notched_shapes.dart';

enum AppTheme { Auto, Light, Dark, Purple }

BrightnessBased<ThemeData> _buildThemeData(AppTheme theme) {
  if (theme == AppTheme.Auto) {
    // Delegate to light and dark theme.
    return BrightnessBased(
          () => _buildThemeData(AppTheme.Light).light,
          () => _buildThemeData(AppTheme.Dark).dark,
    );
  }

  ColorScheme colorScheme;
  switch (theme) {
    case AppTheme.Light:
      colorScheme = ColorScheme.light(
        primary: Colors.grey.shade100,
        primaryVariant: Colors.grey.shade200,
        secondary: Colors.purpleAccent,
        secondaryVariant: Colors.purpleAccent.shade700,
        onPrimary: Colors.black,
      );
      break;
    case AppTheme.Dark:
      colorScheme = ColorScheme.dark(
        primary: Colors.purple,
        primaryVariant: Colors.purple.shade600,
        secondary: Colors.purpleAccent,
        secondaryVariant: Colors.purpleAccent.shade700,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      );
      break;
    case AppTheme.Purple:
      colorScheme = ColorScheme.dark(
        primary: Colors.purple.shade700,
        primaryVariant: Colors.purple.shade800,
        secondary: Colors.purpleAccent,
        secondaryVariant: Colors.purpleAccent.shade700,
        surface: Colors.purple.shade500,
        background: Colors.purple.shade800,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      );
      break;
    case AppTheme.Auto:
      throw StateError("Auto theme is delegate to light and dark theme.");
  }
  var baseTheme = ThemeData.from(colorScheme: colorScheme).copyWith(
      buttonTheme: ButtonThemeData(
        colorScheme: colorScheme.copyWith(
          primary: Colors.purpleAccent,
          primaryVariant: Colors.purpleAccent.shade700,
        ),
        textTheme: ButtonTextTheme.primary,
      ));
  return baseTheme
      .copyWith(
      textTheme: baseTheme.textTheme.withAppFonts(),
      primaryTextTheme: baseTheme.primaryTextTheme.withAppFonts(),
      accentTextTheme: baseTheme.accentTextTheme.withAppFonts(),
      bottomAppBarTheme: baseTheme.bottomAppBarTheme.copyWith(
        shape: StadiumBorderNotchedRectangle(),
      ),
      bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
      ),
      buttonTheme: baseTheme.buttonTheme.copyWith())
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
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
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
        return material?.lighterShade(this) ?? lighten(0.1);
      case SystemUiOverlayTheme.Darken:
        if (this == Colors.white) return Colors.grey.shade100;
        if (this == Colors.transparent) return Colors.black12;
        return material?.darkerShade(this) ?? darken(0.1);
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
    SystemUiOverlayTheme navigationBarTheme = SystemUiOverlayTheme.Same,
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
      systemNavigationBarColor: navigationBarBaseColor.systemUiColor(
          navigationBarTheme),
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
  static const _defaultTheme = AppTheme.Auto;

  AppTheme _theme;

  factory ThemesNotifier() => ThemesNotifier.theme(_defaultTheme);

  ThemesNotifier.theme(AppTheme theme) {
    this.theme = theme;
  }

  AppTheme get theme => _theme;

  set theme(AppTheme theme) {
    if (theme != null) {
      _theme = theme;
      notifyListeners();
    }
  }

  BrightnessBased<ThemeData> get themeData => _buildThemeData(theme);
}
