import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/app_theme.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:txt/widget/txt_icons.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/settings/themes';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Themes'.toUpperCase()),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            _ColorSchemeCard(
              colorScheme: AppColorScheme.Auto,
              name: "Auto theme",
              subtitle: "A wonderful theme",
              description: "This is where you write a note to "
                  "show off this beautiful theme.",
              icon: TxtIcons.themeAuto,
            ),
            _ColorSchemeCard(
              colorScheme: AppColorScheme.Light,
              name: "Light theme",
              subtitle: "A wonderful theme",
              description: "This is where you write a note to "
                  "show off this beautiful theme.",
              icon: TxtIcons.themeLight,
            ),
            _ColorSchemeCard(
              colorScheme: AppColorScheme.Dark,
              name: "Dark theme",
              subtitle: "A wonderful theme",
              description: "This is where you write a note to "
                  "show off this beautiful theme.",
              icon: TxtIcons.themeDark,
            ),
            _ColorSchemeCard(
              colorScheme: AppColorScheme.Purple,
              name: "Purple theme",
              subtitle: "A wonderful theme",
              description: "This is where you write a note to "
                  "show off this beautiful theme.",
              icon: TxtIcons.themePurple,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

@immutable
class _ColorSchemeCard extends StatelessWidget {
  final AppColorScheme colorScheme;
  final String name;
  final String subtitle;
  final String description;
  final IconData icon;

  _ColorSchemeCard({
    Key key,
    @required this.colorScheme,
    @required this.name,
    this.subtitle,
    this.description,
    this.icon,
  });

  _isThemeSelected(BuildContext context) {
    return AppTheme.of(context).colorScheme == colorScheme;
  }

  _selectTheme(BuildContext context) {
    Timer(Duration(milliseconds: 150), () {
      AppTheme.of(context, listen: false).colorScheme = colorScheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getThemeData(colorScheme, context),
      child: Builder(builder: (BuildContext context) {
        List<Widget> cardRows = [
          ListTile(
            leading: icon != null ? Icon(icon) : null,
            title: Text(name),
            trailing: Checkbox(
              value: _isThemeSelected(context),
              onChanged: (value) {},
            ),
          ),
        ];
        if (subtitle != null) {
          cardRows.add(
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          );
        }
        if (description != null) {
          cardRows.add(
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Text(
                description,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          );
        }
        ShapeBorder cardShape = Theme.of(context).cardTheme.shape;
        return Card(
          child: InkWell(
            onTap: () {
              _selectTheme(context);
            },
            borderRadius: cardShape is RoundedRectangleBorder
                ? cardShape.borderRadius
                : null,
            child: Column(
              children: cardRows,
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        );
      }),
    );
  }
}
