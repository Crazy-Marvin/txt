import 'dart:collection';

import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:markdown/markdown.dart';

abstract class NodeRenderer<T> implements NodeVisitor {
  T render(List<Node> nodes);
}

@widgets.immutable
class TextSpanRenderer implements NodeRenderer<widgets.TextSpan> {
  TextStyle get _affixStyle => TextStyle(
      color: theme?.colorScheme?.secondary ?? material.Colors.black45);

  final material.ThemeData theme;
  final bool stripMarkdown;
  final Queue<Queue<widgets.TextSpan>> childQueue = Queue();

  TextSpanRenderer({
    this.theme,
    this.stripMarkdown = true,
  });

  @override
  widgets.TextSpan render(List<Node> nodes) {
    childQueue.clear();
    childQueue.add(Queue());
    assert(childQueue.length == 1);

    for (final node in nodes) node.accept(this);

    assert(childQueue.length == 1);
    Queue<TextSpan> rootQueue = childQueue.last;

    var span = TextSpan(children: rootQueue.toList(growable: false));
    childQueue.clear();

    return span;
  }

  @override
  bool visitElementBefore(Element element) {
    childQueue.add(Queue());
    return true;
  }

  @override
  void visitElementAfter(Element element) {
    TextStyle style;
    String prefix = "";
    String suffix = "";

    switch (element.tag) {
      case "p":
        // Do not style paragraphs. TODO Add a paragraph sign?
        break;
      case "em":
      case "i":
        style = widgets.TextStyle(
          fontStyle: widgets.FontStyle.italic,
        );
        prefix = "_";
        suffix = "_";
        break;
      case "del":
      case "strike":
        style = widgets.TextStyle(
          decoration: TextDecoration.lineThrough,
        );
        prefix = "~~";
        suffix = "~~";
        break;
      case "code":
        style = widgets.TextStyle(
          fontFamily: "monospace",
        );
        prefix = "`";
        suffix = "`";
        break;
      case "strong":
      case "b":
        style = widgets.TextStyle(
          fontWeight: widgets.FontWeight.bold,
        );
        prefix = "**";
        suffix = "**";
        break;
      case "a":
        style = widgets.TextStyle(
          decoration: TextDecoration.underline,
        );
        prefix = "[";
        suffix = "](${element.attributes["href"]})";
        break;
      default:
        debugPrint("Unknown tag: ${element.tag}");
        break;
    }

    var children = childQueue.last.toList(growable: false);
    var span = TextSpan(
      style: style,
      children: stripMarkdown
          ? children
          : [
              TextSpan(
                style: _affixStyle,
                text: prefix,
              ),
              ...children,
              TextSpan(
                style: _affixStyle,
                text: suffix,
              ),
            ],
    );

    childQueue.removeLast();
    childQueue.last.add(span);
  }

  @override
  void visitText(Text text) {
    childQueue.last.add(
      widgets.TextSpan(
        text: text.text,
      ),
    );
  }
}
