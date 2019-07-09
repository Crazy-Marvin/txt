import 'package:flutter/widgets.dart';
import 'package:markdown/markdown.dart';

abstract class MarkdownRenderer<T> implements NodeVisitor {
  T render(List<Node> nodes);
}

abstract class MarkdownWidgetRenderer implements MarkdownRenderer<Widget> {}

abstract class MarkdownTextSpanRenderer implements MarkdownRenderer<TextSpan> {}
