import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return SystemUiOverlayRegion(
      child: Scaffold(
        appBar: AppBar(
          title: Text('About txt'.toUpperCase()),
        ),
        body: Text('Nothing here'),
      ),
    );
  }
}
