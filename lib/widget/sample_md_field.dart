import 'package:flutter/material.dart';
import 'package:txt/markdown/text_editing_controller.dart';

import '../markdown_sample.dart';

class SampleMarkdownTextField extends StatelessWidget {
  TextEditingController controller = MarkdownTextEditingController(
    text:
        "_Another_ test **bold** and ~~lol~~, that's [a link](http://highway.to.hell/index.php). Want some `code`? Wonderfull!"
        "\n\n$markdownSample",
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            // Don't limit lines.
            style: TextStyle(fontFamily: "monospace"),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16.0)),
          ),
        ),
      );
    });
  }
}
