import 'package:flutter/material.dart';
import 'package:txt/model/note.dart';
import 'package:txt/widget/system_ui.dart';

class EditorScreen extends StatelessWidget {
  static const routeName = '/edit';

  @override
  Widget build(BuildContext context) {
    final Note note = ModalRoute.of(context).settings.arguments;

    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(),
        body: Text('Nothing here'),
      ),
    );
  }
}
