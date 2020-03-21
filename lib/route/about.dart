import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/about';

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends SystemUiState<AboutScreen>
    with SystemUiRouteObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About txt'),
      ),
      body: Text('Nothing here'),
    );
  }
}
