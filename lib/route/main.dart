import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:txt/route/settings.dart';
import 'package:txt/widget/system_ui.dart';

import '../themes.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends SystemUiState<MainScreen>
    with SystemUiRouteObserver {
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (builder) => MainMenu(),
    );
  }

  void _showSort(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => MainSortList(),
    );
  }

  @override
  SystemUiOverlayStyle get systemUIOverlayStyle {
    return Theme.of(context).systemUiOverlayStyle(
      hasTopAppBar: false,
      hasBottomAppBar: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).withTranslucentAppBar(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'txt',
          ),
          leading: Icon(MdiIcons.checkboxBlankOutline),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => _showMenu(context),
              ),
              IconButton(
                icon: Icon(MdiIcons.sortVariant),
                onPressed: () => _showSort(context),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO
          },
          label: Text('New draft'.toUpperCase()),
          icon: Icon(MdiIcons.plus),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text("Fix navbar color"),
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(
                    Theme.of(context).systemUiOverlayStyle(
                        hasTopAppBar: false, hasBottomAppBar: true),
                  );
                },
              ),
              RaisedButton(
                child: Text("Settings"),
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainSortList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Placeholder");
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.65,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: ListTile(
              leading: Icon(MdiIcons.checkboxBlankOutline),
              title: Text('John Doe'),
            ),
          ),
          Divider(indent: 72),
          ListTile(
            leading: Icon(MdiIcons.fileDocumentOutline),
            title: Text('All drafts'),
          ),
          ListTile(
            leading: Icon(MdiIcons.archiveOutline),
            title: Text('Archive'),
          ),
          ListTile(
            leading: Icon(MdiIcons.deleteOutline),
            title: Text('Trash'),
          ),
          Divider(indent: 72),
          ListTile(
            leading: Icon(MdiIcons.labelOutline, color: Colors.lightBlue),
            title: Text('Recipes', style: TextStyle(color: Colors.lightBlue)),
          ),
          ListTile(
            leading: Icon(MdiIcons.labelOutline, color: Colors.lightGreen),
            title:
            Text('University', style: TextStyle(color: Colors.lightGreen)),
          ),
          Divider(indent: 72),
          ListTile(
            leading: Icon(MdiIcons.pencilOutline),
            title: Text('Edit labels'),
          ),
          ListTile(
            leading: Icon(MdiIcons.cogOutline),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
