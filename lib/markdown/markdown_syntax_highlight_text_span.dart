import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:txt/markdown/renderer.dart';
import 'package:txt/text/text_span_utils.dart';

@immutable
class MarkdownSyntaxHighlightTextSpan extends TextSpan {
  static final Pattern lineSeparator = RegExp("\r?\n");

  MarkdownSyntaxHighlightTextSpan._renderer(
    MarkdownTextSpanRenderer renderer,
    List<md.Node> nodes,
  ) : super(children: [renderer.render(nodes)]);

  MarkdownSyntaxHighlightTextSpan._empty() : super();

  factory MarkdownSyntaxHighlightTextSpan({
    @required String data,
  }) {
    md.Document document = md.Document(
      extensionSet: md.ExtensionSet.gitHubWeb,
    );

    if (data == null) {
      return MarkdownSyntaxHighlightTextSpan._empty();
    }

    List<String> lines = data.split(lineSeparator);
    List<md.Node> nodes = document.parseLines(lines);

    MarkdownTextSpanRenderer renderer = _MarkdownSyntaxHighlightRenderer(data);

    return MarkdownSyntaxHighlightTextSpan._renderer(renderer, nodes);
  }
}

class _MarkdownSyntaxStyles {
  static const TextStyle a = TextStyle(decoration: TextDecoration.underline);
  static const TextStyle code = TextStyle(fontFamily: "monospace");
  static const TextStyle h1 = TextStyle(fontWeight: FontWeight.w900);
  static const TextStyle h2 = TextStyle(fontWeight: FontWeight.w900);
  static const TextStyle h3 = TextStyle(fontWeight: FontWeight.w800);
  static const TextStyle h4 = TextStyle(fontWeight: FontWeight.w800);
  static const TextStyle h5 = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle h6 = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle em = TextStyle(fontStyle: FontStyle.italic);
  static const TextStyle strong = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle del =
      TextStyle(decoration: TextDecoration.lineThrough);
  static const TextStyle blockquote = TextStyle(fontStyle: FontStyle.italic);
  static const TextStyle img = TextStyle(color: Colors.blue);
  static const TextStyle th = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle syntax = TextStyle(color: Colors.black45);
}

class _MarkdownSyntaxHighlightRenderer implements MarkdownTextSpanRenderer {
  static final HtmlUnescape _unescape = HtmlUnescape();

  final String markdown;

  Queue<TextStyle> _currentStyle;
  int _textSearchPointer;
  TextSpan _markdownSpan;

  _MarkdownSyntaxHighlightRenderer(this.markdown);

  @override
  TextSpan render(List<md.Node> nodes) {
    _currentStyle = Queue();
    _textSearchPointer = 0;
    _markdownSpan = TextSpan(text: markdown);

    for (final node in nodes) node.accept(this);

    _applyMetaTextStyle(start: _textSearchPointer, end: markdown.length - 1);

    return _markdownSpan;
  }

  @override
  bool visitElementBefore(md.Element element) {
    switch (element.tag) {
      case "img":
        _currentStyle.add(_MarkdownSyntaxStyles.img);
        // Workaround to highlight `img` tag's `alt` attribute
        // similar to the `a` tag's text.
        visitText(md.Text(element.attributes["alt"]));
        return true;
      case "a":
        _currentStyle.add(_MarkdownSyntaxStyles.a);
        return true;
      case "code":
        _currentStyle.add(_MarkdownSyntaxStyles.code);
        return true;
      case "h1":
        _currentStyle.add(_MarkdownSyntaxStyles.h1);
        return true;
      case "h2":
        _currentStyle.add(_MarkdownSyntaxStyles.h2);
        return true;
      case "h3":
        _currentStyle.add(_MarkdownSyntaxStyles.h3);
        return true;
      case "h4":
        _currentStyle.add(_MarkdownSyntaxStyles.h4);
        return true;
      case "h5":
        _currentStyle.add(_MarkdownSyntaxStyles.h5);
        return true;
      case "h6":
        _currentStyle.add(_MarkdownSyntaxStyles.h6);
        return true;
      case "em":
        _currentStyle.add(_MarkdownSyntaxStyles.em);
        return true;
      case "strong":
        _currentStyle.add(_MarkdownSyntaxStyles.strong);
        return true;
      case "del":
        _currentStyle.add(_MarkdownSyntaxStyles.del);
        return true;
      case "blockquote":
        _currentStyle.add(_MarkdownSyntaxStyles.blockquote);
        return true;
      case "p":
      case "li":
      case "ul":
      case "ol":
      default:
        _currentStyle.add(null);
        return true;
    }
  }

  @override
  void visitElementAfter(md.Element element) {
    _currentStyle.removeLast();
  }

  @override
  void visitText(md.Text text) {
    String textContent = text.text;
    textContent = _unescape.convert(textContent);

    int start = markdown.indexOf(textContent, _textSearchPointer);
    int end = start + textContent.length;

    _applyMetaTextStyle(start: _textSearchPointer, end: start);

    _currentStyle.forEach((style) {
      if (style != null) {
        _applyTextStyle(style: style, start: start, end: end);
      }
    });

    _textSearchPointer = end;
  }

  void _applyTextStyle({
    @required TextStyle style,
    @required int start,
    @required int end,
  }) {
    TextRange range = TextRange(start: start, end: end);
    _markdownSpan = applyTextStyle(_markdownSpan, range, style);
  }

  void _applyMetaTextStyle({
    @required int start,
    @required int end,
  }) {
    _applyTextStyle(
        style: _MarkdownSyntaxStyles.syntax, start: start, end: end);
  }
}
