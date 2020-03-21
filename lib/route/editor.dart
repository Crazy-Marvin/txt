import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class EditorScreen extends StatelessWidget {
  static const routeName = '/edit';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(),
        body: Text('Nothing here'),
      ),
    );
  }
}
