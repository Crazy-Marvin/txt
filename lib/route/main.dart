import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:txt/route/settings.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/system_ui.dart';

class MainScreen extends StatelessWidget {
  static const routeName = '/';

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
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Theme(
        data: Theme.of(context).withTranslucentAppBar(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'txt'.toUpperCase(),
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
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
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
                  child: Text("Settings"),
                  onPressed: () {
                    Navigator.pushNamed(context, SettingsScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context) =>
          Theme.of(context).systemUiOverlayStyle(
            hasTopAppBar: false,
            hasBottomAppBar: true,
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
