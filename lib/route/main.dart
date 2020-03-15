import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class MainRoute extends StatelessWidget {

  void showMenu(BuildContext context) {
    // TODO
  }

  void showSort(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 300.0,
            child: Center(
              child: Text(
                  "This is a modal sheet\n\n\n\n\n\n\nThis is a modal sheet"),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DRAFT',
          style: Theme
              .of(context)
              .textTheme
              .title,
        ),
        leading: Icon(Icons.check_box_outline_blank),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => showMenu(context),
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () => showSort(context),
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
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("Light"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Light;
                  },
                ),
                RaisedButton(
                  child: Text("Dark"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Dark;
                  },
                ),
                RaisedButton(
                  child: Text("Purple"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Purple;
                  },
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text("Light"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Light;
                  },
                ),
                FlatButton(
                  child: Text("Dark"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Dark;
                  },
                ),
                FlatButton(
                  child: Text("Purple"),
                  onPressed: () {
                    Provider
                        .of<ThemesNotifier>(context, listen: false)
                        .theme = AppTheme.Purple;
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
