import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/system_ui.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends SystemUiState<SettingsScreen>
    with SystemUiRouteObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Fix navbar color"),
            onPressed: () {
              SystemChrome.setSystemUIOverlayStyle(
                Theme.of(context).systemUiOverlayStyle(),
              );
            },
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("Auto"),
                onPressed: () {
                  Provider
                      .of<ThemesNotifier>(context, listen: false)
                      .theme =
                      AppTheme.Auto;
                },
              ),
              RaisedButton(
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
    );
  }
}
