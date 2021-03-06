import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

TextSpan flatten(TextSpan span) {
  if (span.text == null) {
    if (span.children.length == 1) {
      InlineSpan firstChild = span.children.first;
      if (firstChild is TextSpan) {
        return TextSpan(
          text: firstChild.text,
          children: firstChild.children,
          style: span.style.merge(firstChild.style),
          recognizer: firstChild.recognizer,
          semanticsLabel: firstChild.semanticsLabel ?? span.semanticsLabel,
        );
      }
    }
  }
  return span;
}

/// Inside the given [range], apply the [style] to the [span].
TextSpan applyTextStyle(TextSpan span, TextRange range, TextStyle style) {
  assert(span != null);
  assert(range != null);

  TextRange spanRange = TextSpanTextRange(span);

  // If the range doesn't contain anything we don't need to change any style.
  if (_intersectRange(range, spanRange).isCollapsed) {
    return span;
  }

  // If the range contains the whole span, we can wrap the whole span.
  if (_containsRange(range, spanRange)) {
    return TextSpan(style: style, children: [span]);
  }

  return TextSpan(
    style: span.style,
    children: List.from(_applyTextStyleToText(span.text, range, style))
      ..addAll(_applyTextStyleToTextSpans(span.children, range, style)),
    recognizer: span.recognizer,
    semanticsLabel: span.semanticsLabel,
  );
}

/// Inside the given [range], apply the [style] to the [text].
Iterable<TextSpan> _applyTextStyleToText(
    String text, TextRange range, TextStyle style) {
  if (text == null) return [];

  range = _intersectRange(range, StringTextRange(text));

  if (!range.isValid) {
    return [
      TextSpan(text: text),
    ];
  }

  return [
    TextSpan(
      text: range.textBefore(text),
    ),
    TextSpan(
      style: style,
      text: range.textInside(text),
    ),
    TextSpan(
      text: range.textAfter(text),
    ),
  ];
}

/// Inside the given [range], apply the [style] to the [spans].
Iterable<TextSpan> _applyTextStyleToTextSpans(
    Iterable<InlineSpan> spans, TextRange range, TextStyle style) {
  if (spans == null) return [];

  var off = 0;
  return spans.map((InlineSpan span) {
    TextSpan newSpan = applyTextStyle(span, _offsetRange(range, off), style);
    off -= _length(span);
    return newSpan;
  });
}

/// Text range that contains exactly a [String].
@immutable
class StringTextRange extends TextRange {
  const StringTextRange(String text) : super(start: 0, end: text.length);
}

/// Text range that contains exactly a [TextRange].
@immutable
class TextSpanTextRange extends TextRange {
  TextSpanTextRange(TextSpan span) : super(start: 0, end: _length(span));
}

/// Increment the [receiver] range's start and end positions
/// by the given [offset].
TextRange _offsetRange(TextRange receiver, int offset) {
  return TextRange(
    start: max(receiver.start + offset, -1),
    end: max(receiver.end + offset, -1),
  );
}

/// Intersect the [receiver] range with the [other] range.
/// If the intersection is empty [TextRange.empty] is returned.
TextRange _intersectRange(TextRange receiver, TextRange other) {
  int start = max(receiver.start, other.start);
  int end = min(receiver.end, other.end);
  if (end < start) return TextRange.empty;
  return TextRange(start: start, end: end);
}

/// Check, whether the [receiver] range fully contains the [other] range.
bool _containsRange(TextRange receiver, TextRange other) =>
    receiver.start <= other.start && other.end <= receiver.end;

/// Get the total length of the [receiver] span.
int _length(TextSpan receiver) {
  int result = 0;
  if (receiver.text != null) {
    result += receiver.text.length;
  }
  if (receiver.children != null) {
    for (TextSpan child in receiver.children) {
      result += _length(child);
    }
  }
  return result;
}
