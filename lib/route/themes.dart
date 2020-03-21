import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/settings/themes';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Themes'.toUpperCase()),
        ),
        body: Text('Nothing here'),
      ),
    );
  }
}
