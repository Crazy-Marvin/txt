import 'package:flutter/material.dart';
import 'package:txt/file/note_manager.dart';
import 'package:txt/model/note.dart';
import 'package:txt/route/settings.dart';
import 'package:txt/themes.dart';
import 'package:txt/widget/note_tile.dart';
import 'package:txt/widget/system_ui.dart';
import 'package:txt/widget/txt_icons.dart';

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
    return Theme(
      data: Theme.of(context).withTranslucentAppBar(),
      child: Builder(
        builder: (BuildContext context) {
          return SystemUiOverlayRegion(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'txt'.toUpperCase(),
                ),
                leading: Icon(TxtIcons.blank),
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
                      icon: Icon(TxtIcons.filter),
                      onPressed: () => _showSort(context),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  final snackBar = SnackBar(content: Text('Create new file.'));
                  Scaffold.of(context).showSnackBar(snackBar);
                },
                label: Text('New draft'.toUpperCase()),
                icon: Icon(TxtIcons.add),
              ),
              body: RefreshIndicator(
                onRefresh: () async {},
                child: FutureBuilder(
                  future: NoteManager.list(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Note> notes = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          if (index >= notes.length) return null;
                          return NoteTile(notes[index]);
                        },
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                CircularProgressIndicator(
                                  value: null,
                                ),
                                SizedBox(height: 16),
                                Text("Loading..."),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            builder: (context) => Theme.of(context).systemUiOverlayStyle(
              hasTopAppBar: false,
              hasBottomAppBar: true,
            ),
          );
        },
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
      child: ClipPath(
        clipper:
            ShapeBorderClipper(shape: Theme.of(context).bottomSheetTheme.shape),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: ListTile(
                leading: Icon(TxtIcons.blank),
                title: Text('John Doe'),
              ),
            ),
            Divider(indent: 72),
            ListTile(
              leading: Icon(TxtIcons.document),
              title: Text('All drafts'),
            ),
            ListTile(
              leading: Icon(TxtIcons.archive),
              title: Text('Archive'),
            ),
            ListTile(
              leading: Icon(TxtIcons.trash),
              title: Text('Trash'),
            ),
            Divider(indent: 72),
            ListTile(
              leading: Icon(TxtIcons.label, color: Colors.lightBlue),
              title: Text(
                'Recipes',
                style: TextStyle(color: Colors.lightBlue),
              ),
            ),
            ListTile(
              leading: Icon(TxtIcons.label, color: Colors.lightGreen),
              title: Text(
                'University',
                style: TextStyle(color: Colors.lightGreen),
              ),
            ),
            Divider(indent: 72),
            ListTile(
              leading: Icon(TxtIcons.edit),
              title: Text('Edit labels'),
            ),
            ListTile(
              leading: Icon(TxtIcons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
