import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview';

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends SystemUiState<PreviewScreen>
    with SystemUiRouteObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview'),
      ),
      body: Text('Nothing here'),
    );
  }
}
