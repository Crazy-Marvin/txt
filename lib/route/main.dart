import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:txt/widget/notched_shapes.dart';

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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: RoundedBorderNotchedRectangle(),
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
      body: Text('Nothing here'),
    );
  }
}
