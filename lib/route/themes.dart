import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class ThemesScreen extends StatefulWidget {
  static const routeName = '/settings/themes';

  @override
  _ThemesScreenState createState() => _ThemesScreenState();
}

class _ThemesScreenState extends SystemUiState<ThemesScreen>
    with SystemUiRouteObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Themes'),
      ),
      body: Text('Nothing here'),
    );
  }
}
