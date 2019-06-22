import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Split the [span] at the [range`s] start and end to override
/// the inner text's style.
TextSpan addTextStyleInRange(
    TextSpan span, TextRange range, TextStyle newStyleInRange) {
  assert(range.isValid);
  assert(range.isNormalized);

  // If the range doesn't contain anything we don't need to change any style.
  if (range.isCollapsed || range.start >= _length(span) - 1 || range.end == 0) {
    debugPrint("Pruning because range is collapsed.");
    return span;
  }

  // If the range contains the whole span, we can wrap the whole span.
  if (range.start == 0 && range.end >= _length(span) - 1) {
    debugPrint("Pruning because contains whole span.");
    return TextSpan(style: newStyleInRange, children: [span]);
  }

  debugPrint(range.toString());

  TextSpan startSpan = _getSpanForPosition(span, range.start);
  TextSpan endSpan = _getSpanForPosition(span, range.end);

  debugPrint("span: " + span.toString());
  debugPrint(
      "span (plain): " + span.toPlainText(includeSemanticsLabels: false));
  debugPrint("startSpan: " + startSpan.toString());
  debugPrint("endSpan: " + endSpan.toString());

  assert(startSpan != null);
  assert(endSpan != null);

  String text;
  List<TextSpan> children = [];

  if (startSpan == span) {
    assert(span.text != null);

    // The original span should contain only the text
    // before the range to style.
    text = range.textBefore(span.text);

    // We'll need to move the new styled span into
    // the original span's children list.
    if (endSpan == span) {
      // Create two new spans:
      // the styled one and a text span containing
      // the rest of the original span's text.
      children.add(
        TextSpan(
          style: newStyleInRange,
          text: range.textInside(span.text),
        ),
      );
      children.add(
        TextSpan(
          text: range.textAfter(span.text),
        ),
      );

      // As the range is already exhausted,
      // we can copy the rest of the original span's children
      // and return the new span.
      if (span.children != null) {
        children.addAll(span.children);
      }

      return TextSpan(
        style: span.style,
        text: text,
        children: children,
        recognizer: span.recognizer,
        semanticsLabel: span.semanticsLabel,
      );
    } else {
      // The rest of the original span's text should be styled.
      String startSpanTextInRange = range.textInside(span.text);
      children.add(
        TextSpan(
          style: newStyleInRange,
          text: startSpanTextInRange,
        ),
      );

      // This offset should move the range relative to the current span.
      int offset = -span.text.length;
      // Keep track of the character count, we already consumed
      // of the range of text to style.
      int consumed = startSpanTextInRange.length;

      children.addAll(_addTextStyleInRangeChildren(
          span.children, range, newStyleInRange, offset, consumed));

      return TextSpan(
        style: span.style,
        text: text,
        children: children,
        recognizer: span.recognizer,
        semanticsLabel: span.semanticsLabel,
      );
    }
  } else {
    // Both start and end of the text range are inside
    // the original span's children.

    // This offset should move the range relative to the current span.
    int offset = -(span.text?.length ?? 0);
    // Keep track of the character count, we already consumed
    // of the range of text to style.
    int consumed = 0;

    children.addAll(_addTextStyleInRangeChildren(
        span.children, range, newStyleInRange, offset, consumed));

    return TextSpan(
      style: span.style,
      text: span.text,
      children: children,
      recognizer: span.recognizer,
      semanticsLabel: span.semanticsLabel,
    );
  }
}

List<TextSpan> _addTextStyleInRangeChildren(List<TextSpan> spans,
    TextRange range, TextStyle newStyleInRange, int offset, int consumed) {
  List<TextSpan> children = [];

  for (TextSpan child in spans) {
    // TODO Can we remove this?
    if (range.start + offset < 0 || range.end + offset - consumed < 0) {
      children.add(child);
      continue;
    }

    TextRange offsetRange = TextRange(
      start: range.start + offset,
      end: range.end + offset - consumed,
    );
    debugPrint("offset: $offset");
    debugPrint("consumed: $consumed");
    debugPrint("offsetRange: $offsetRange");
    if (offsetRange.isValid && offsetRange.isNormalized) {
      debugPrint("recursion");
      // The offset range is still not empty.
      // Recursively style the child and add it to the children list.
      children.add(
        addTextStyleInRange(child, offsetRange, newStyleInRange),
      );
      // As we consumed the child and the range must be consecutive,
      // we advance both the offset and the
      int childLength = _length(child);
      offset -= childLength;
      consumed += childLength;
    } else {
      debugPrint("justAdd");
      // The offset range is empty. Just append the child.
      children.add(child);
    }
  }

  return children;
}

int _length(TextSpan span) {
  int result = 0;
  if (span.text != null) {
    result += span.text.length;
  }
  if (span.children != null) {
    for (TextSpan child in span.children) {
      result += _length(child);
    }
  }
  return result;
}

TextSpan _getSpanForPosition(TextSpan span, int position) {
  if (span.text != null) {
    if (position >= 0 && position < span.text.length) return span;
    position -= span.text.length;
  }
  if (span.children != null) {
    for (TextSpan child in span.children) {
      var result = _getSpanForPosition(child, position);
      if (result != null) return result;
      position -= _length(child);
    }
  }
  return null;
}
