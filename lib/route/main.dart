import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainRoute extends StatelessWidget {
  void openMenu() {
    // TODO
  }

  void openSort() {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DRAFT'),
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
              onPressed: openMenu,
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: openSort,
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
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Nothing here'),
      ),
    );
  }
}
