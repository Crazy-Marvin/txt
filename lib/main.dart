import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:txt/markdown/markdown_syntax_highlight_text_span.dart';
import 'package:txt/markdown/markdown_text_field.dart';

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
      "_Another_ test **bold** and ~~lol~~, that's [a link](http://highway.to.hell/index.php). Want some `code`? Wonderfull!"
//          "\n\n$markdownSample"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text.rich(
          MarkdownSyntaxHighlightTextSpan(
            data: "**Reading** ~~and~~ _Writing_ `xml`-files",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(fontFamily: "monospace"),
                        ),
                      ),
                      Expanded(
                        child: MarkdownTextField(
                          controller: controller,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(fontFamily: "monospace"),
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    MarkdownSyntaxHighlightTextSpan(
                      data: "Button tapped **$_counter** "
                          "time${_counter == 1 ? "" : "s"}.",
                    ),
                  ),
                  Text.rich(
                    MarkdownSyntaxHighlightTextSpan(
                      data: controller.value.text,
                    ),
                  ),
                  MarkdownBody(
                    data: controller.value.text,
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
