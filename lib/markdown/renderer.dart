import 'dart:collection';

import 'package:flutter/rendering.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:markdown/markdown.dart';
import 'package:meta/meta.dart';

import 'styles.dart';
import 'utils.dart';

abstract class MarkdownRenderer<T> implements NodeVisitor {
  T render(List<Node> nodes);
}

class MarkdownSyntaxRenderer implements MarkdownRenderer<TextSpan> {
  static final HtmlUnescape _unescape = HtmlUnescape();
  static final Pattern _lineSeparator = RegExp("\r?\n");

  final String markdown;

  Queue<TextStyle> _currentStyle;
  int _textSearchPointer;
  TextSpan _markdownSpan;

  MarkdownSyntaxRenderer(this.markdown) {
    assert(
      markdown != null,
      'Markdown text must be provided to a MarkdownSyntaxRenderer.',
    );
  }

  @override
  TextSpan render(List<Node> nodes) {
    _currentStyle = Queue();
    _textSearchPointer = 0;
    _markdownSpan = TextSpan(text: markdown);

    for (final node in nodes) node.accept(this);

    _applyMetaTextStyle(start: _textSearchPointer, end: markdown.length - 1);

    return _markdownSpan;
  }

  @override
  bool visitElementBefore(Element element) {
    switch (element.tag) {
      case "img":
        _currentStyle.add(MarkdownSyntaxStyles.img);
        // Workaround to highlight `img` tag's `alt` attribute
        // similar to the `a` tag's text.
        visitText(Text(element.attributes["alt"]));
        return true;
      case "a":
        _currentStyle.add(MarkdownSyntaxStyles.a);
        return true;
      case "code":
        _currentStyle.add(MarkdownSyntaxStyles.code);
        return true;
      case "h1":
        _currentStyle.add(MarkdownSyntaxStyles.h1);
        return true;
      case "h2":
        _currentStyle.add(MarkdownSyntaxStyles.h2);
        return true;
      case "h3":
        _currentStyle.add(MarkdownSyntaxStyles.h3);
        return true;
      case "h4":
        _currentStyle.add(MarkdownSyntaxStyles.h4);
        return true;
      case "h5":
        _currentStyle.add(MarkdownSyntaxStyles.h5);
        return true;
      case "h6":
        _currentStyle.add(MarkdownSyntaxStyles.h6);
        return true;
      case "em":
        _currentStyle.add(MarkdownSyntaxStyles.em);
        return true;
      case "strong":
        _currentStyle.add(MarkdownSyntaxStyles.strong);
        return true;
      case "del":
        _currentStyle.add(MarkdownSyntaxStyles.del);
        return true;
      case "blockquote":
        _currentStyle.add(MarkdownSyntaxStyles.blockquote);
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
  void visitElementAfter(Element element) {
    _currentStyle.removeLast();
  }

  @override
  void visitText(Text text) {
    String textContent = text.text;
    textContent.split(_lineSeparator).forEach((line) {
      visitTextLine(line);
    });
  }

  void visitTextLine(String line) {
    line = _unescape.convert(line);

    int start = markdown.indexOf(line, _textSearchPointer);
    if (start == -1) {
      debugPrint("WARNING: Could not find '$line'.");
      return;
    }
    int end = start + line.length;

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
    _applyTextStyle(style: MarkdownSyntaxStyles.syntax, start: start, end: end);
  }
}

class StripMarkdownRenderer implements MarkdownRenderer<String> {
  static final Set<String> _ignoredTags = {
    "img",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6"
  };

  StringBuffer _output;
  int _outputIgnored;

  @override
  String render(List<Node> nodes) {
    _output = StringBuffer();
    _outputIgnored = 0;
    for (final node in nodes) node.accept(this);
    return _output.toString();
  }

  @override
  bool visitElementBefore(Element element) {
    if (_ignoredTags.contains(element.tag)) {
      _outputIgnored++;
    }
    return true;
  }

  @override
  void visitElementAfter(Element element) {
    if (_ignoredTags.contains(element.tag)) {
      _outputIgnored--;
    }
    if (_ignoredTags.contains(element.tag)) {
      _output.write("\n");
    }
  }

  @override
  void visitText(Text text) {
    if (_outputIgnored == 0) {
      _output.write(text.text);
    }
  }
}
