import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:txt/route/main.dart';
import 'package:txt/themes.dart';

import 'markdown/text_editing_controller.dart';
import 'markdown_sample.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemesNotifier(),
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController controller = MarkdownTextEditingController(
    text:
        "_Another_ test **bold** and ~~lol~~, that's [a link](http://highway.to.hell/index.php). Want some `code`? Wonderfull!"
        "\n\n$markdownSample",
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: Provider
          .of<ThemesNotifier>(context)
          .systemUiOverlayStyle,
      child: MaterialApp(
        title: 'txt',
        home: MainRoute(),
        theme: Provider
            .of<ThemesNotifier>(context)
            .themeData,
      ),
    );
  }
}
