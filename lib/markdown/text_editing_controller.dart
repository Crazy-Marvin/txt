import 'package:flutter/widgets.dart';
import 'package:txt/markdown/text_span.dart';
import 'package:txt/markdown/utils.dart';

class MarkdownTextEditingController extends TextEditingController {
  static const TextStyle _composingStyle = const TextStyle(
    decoration: TextDecoration.underline,
  );

  MarkdownTextEditingController({String text}) : super(text: text);

  MarkdownTextEditingController.fromValue(TextEditingValue value)
      : super.fromValue(value);

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    TextSpan span = MarkdownSyntaxTextSpan(
      data: value.text,
    );

    if (value.composing.isValid && withComposing) {
      span = applyTextStyle(span, value.composing, style.merge(_composingStyle));
    }

    return TextSpan(
      style: style,
      children: [span],
    );
  }
}
