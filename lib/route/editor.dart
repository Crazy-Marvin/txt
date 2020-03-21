import 'package:flutter/material.dart';
import 'package:txt/widget/system_ui.dart';

class EditorScreen extends StatefulWidget {
  static const routeName = '/edit';

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends SystemUiState<EditorScreen>
    with SystemUiRouteObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('Nothing here'),
    );
  }
}
