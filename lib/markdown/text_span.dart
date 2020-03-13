import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;

import 'renderer.dart';

@immutable
class MarkdownSyntaxTextSpan extends TextSpan {
  static final Pattern lineSeparator = RegExp("\r?\n");

  MarkdownSyntaxTextSpan._copy(
    TextSpan span,
  ) : super(
          style: span.style,
          text: span.text,
          children: span.children,
          recognizer: span.recognizer,
          semanticsLabel: span.semanticsLabel,
        );

  factory MarkdownSyntaxTextSpan({
    @required String data,
  }) {
    assert(
      data != null,
      'Markdown text must be provided to a MarkdownSyntaxTextSpan.',
    );

    md.Document document = md.Document(
      extensionSet: md.ExtensionSet.gitHubWeb,
    );

    List<String> lines = data.split(lineSeparator);
    List<md.Node> nodes = document.parseLines(lines);

    MarkdownRenderer<TextSpan> renderer = MarkdownSyntaxRenderer(data);

    TextSpan span = renderer.render(nodes);

    return MarkdownSyntaxTextSpan._copy(span);
  }
}
