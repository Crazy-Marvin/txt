import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart';

import '../inline_markdown_renderer.dart';

@immutable
class MarkdownTextSpan extends TextSpan {
  const MarkdownTextSpan._internal({
    TextStyle style,
    List<TextSpan> children,
    GestureRecognizer recognizer,
    String semanticsLabel,
  }) : super(
            style: style,
            children: children,
            recognizer: recognizer,
            semanticsLabel: semanticsLabel);

  factory MarkdownTextSpan({
    TextStyle style,
    String text,
    List<TextSpan> children,
    GestureRecognizer recognizer,
    String semanticsLabel,
    bool stripMarkdown = true,
  }) {
    Document document = Document(
      blockSyntaxes: [],
      inlineSyntaxes: ExtensionSet.gitHubFlavored.inlineSyntaxes,
      extensionSet: ExtensionSet.none,
    );
    List<String> lines = text?.replaceAll('\r\n', '\n')?.split('\n') ?? [];
    List<Node> nodes = document.parseLines(lines);
    TextSpanRenderer renderer = TextSpanRenderer(stripMarkdown: stripMarkdown);
    TextSpan markdownSpan = renderer.render(nodes);

    List<TextSpan> allChildren = [markdownSpan];
    if (children != null) {
      allChildren.addAll(children);
    }

    return MarkdownTextSpan._internal(
        style: style,
        children: allChildren,
        recognizer: recognizer,
        semanticsLabel: semanticsLabel);
  }
}
