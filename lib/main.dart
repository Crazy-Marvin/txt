import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:txt/text/markdown_text_span.dart';
import 'package:txt/text/text_span_utils.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: MyApp(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class MyApp extends StatefulWidget {
  final CounterStorage storage;

  MyApp({Key key, @required this.storage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  TextEditingController controller = TextEditingController(
      text:
      "_Another_ test **bold** and ~~lol~~, that's [a link](http://highway.to.hell/index.php)");

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          MarkdownTextSpan(text: "**Reading** ~~and~~ _Writing_ `xml`-files"),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                children: <Widget>[
//                  TextField(
//                    controller: controller,
//                    keyboardType: TextInputType.multiline,
//                    maxLines: null,
//                  ),
//                  MarkdownTextField(
//                    controller: controller,
//                    keyboardType: TextInputType.multiline,
//                    maxLines: null,
//                  ),
                  Text.rich(
                    MarkdownTextSpan(
                        text: "Button tapped **$_counter** time${_counter == 1
                            ? ''
                            : 's'}."),
                  ),
                  OverlaySpanTest(
                    textSpan: MarkdownTextSpan(
                      text: "_Another_ test **bold** and ~~lol~~, "
                          "that's [a link](http://highway.to.hell/index.php)",
                    ),
                  ),
                  OverlaySpanTest(
                    textSpan: MarkdownTextSpan(
                      text: "_Another_ test **bold** and ~~lol~~, "
                          "that's [a link](http://highway.to.hell/index.php)",
                      stripMarkdown: false,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class OverlaySpanTest extends StatelessWidget {
  static const TextStyle _defaultOverlayStyle = const TextStyle(
    backgroundColor: Color.fromRGBO(255, 255, 0, 0.75),
  );

  final TextSpan textSpan;
  final TextStyle overlayStyle;

  int get length => _textSpanLength(textSpan);

  const OverlaySpanTest({
    Key key,
    this.textSpan,
    this.overlayStyle = _defaultOverlayStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(length, (int position) {
        return Text.rich(
          applyTextStyle(
            textSpan,
            TextRange(start: position, end: position + 1),
            overlayStyle,
          ),
        );
      }),
    );
  }

  int _textSpanLength(TextSpan span) {
    int result = 0;
    if (span.text != null) {
      result += span.text.length;
    }
    if (span.children != null) {
      for (TextSpan child in span.children) {
        result += _textSpanLength(child);
      }
    }
    return result;
  }
}
