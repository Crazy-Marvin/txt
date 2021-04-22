import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:txt/route/about.dart';
import 'package:txt/route/editor.dart';
import 'package:txt/route/main.dart';
import 'package:txt/route/preview.dart';
import 'package:txt/route/settings.dart';
import 'package:txt/route/themes.dart';
import 'package:txt/widget/app_theme.dart';

import 'markdown/text_editing_controller.dart';
import 'markdown_sample.dart';

void main() {
  runApp(
    App(),
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
    debugPaintSizeEnabled = false;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return AppTheme(
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'txt',
          theme: AppTheme.of(context).themeData.light,
          darkTheme: AppTheme.of(context).themeData.dark,
          initialRoute: MainScreen.routeName,
          routes: {
            MainScreen.routeName: (context) => MainScreen(),
            AboutScreen.routeName: (context) => AboutScreen(),
            EditorScreen.routeName: (context) => EditorScreen(),
            PreviewScreen.routeName: (context) => PreviewScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            ThemesScreen.routeName: (context) => ThemesScreen(),
          },
        );
      }),
    );
  }
}
