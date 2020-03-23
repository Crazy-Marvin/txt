import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txt/themes.dart';

class AppTheme extends SingleChildStatelessWidget {
  static const AppColorScheme _defaultColorScheme = AppColorScheme.Auto;

  AppTheme({Key key, Widget child}) : super(key: key, child: child);

  static AppThemeEditor of(BuildContext context, {bool listen = true}) =>
      Provider.of<_Notifier>(context, listen: listen);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return ChangeNotifierProvider(
      create: (_) => _Notifier(_defaultColorScheme),
      child: child,
    );
  }
}

class _Notifier with ChangeNotifier implements AppThemeEditor {
  static const String _preferencesKey = "app_theme";

  final AppColorScheme _preLoadColorScheme;
  AppColorScheme _colorScheme;

  _Notifier(this._preLoadColorScheme) {
    assert(_preLoadColorScheme != null);
    _init();
  }

  Future<void> _init() async {
    AppColorScheme colorScheme = await _loadPreference();
    if (_colorScheme == null) {
      this.colorScheme = colorScheme;
    }
  }

  AppColorScheme get colorScheme => _colorScheme ?? _preLoadColorScheme;

  set colorScheme(AppColorScheme colorScheme) {
    assert(colorScheme != null);
    _colorScheme = colorScheme;
    _savePreference(colorScheme);
    notifyListeners();
  }

  static Future<AppColorScheme> _loadPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey(_preferencesKey)) return null;
    return AppColorScheme.values[preferences.getInt(_preferencesKey)];
  }

  static Future<bool> _savePreference(AppColorScheme colorScheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(
      _preferencesKey,
      AppColorScheme.values.indexOf(colorScheme),
    );
  }

  BrightnessBased<ThemeData> get themeData =>
      getBrightnessBasedThemeData(colorScheme);
}
