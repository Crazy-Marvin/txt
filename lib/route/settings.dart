import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/system_ui.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'.toUpperCase()),
        ),
        body: Column(
          children: <Widget>[
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text("Auto"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme =
                        AppTheme.Auto;
                  },
                ),
                OutlineButton(
                  child: Text("Light"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme =
                        AppTheme.Light;
                  },
                ),
                RaisedButton(
                  child: Text("Dark"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme =
                        AppTheme.Dark;
                  },
                ),
                RaisedButton(
                  child: Text("Purple"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme =
                        AppTheme.Purple;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
