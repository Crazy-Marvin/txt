import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class PreviewScreen extends StatelessWidget {
  static const routeName = '/preview';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Preview'.toUpperCase()),
        ),
        body: Text('Nothing here'),
      ),
    );
  }
}
