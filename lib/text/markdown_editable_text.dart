import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'markdown_text_span.dart';

class MarkdownEditableText extends EditableText {
  MarkdownEditableText({
    Key key,
    @required TextEditingController controller,
    @required FocusNode focusNode,
    bool obscureText = false,
    bool autocorrect = true,
    @required TextStyle style,
    StrutStyle strutStyle,
    @required Color cursorColor,
    @required Color backgroundCursorColor,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection,
    Locale locale,
    double textScaleFactor,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    bool autofocus = false,
    Color selectionColor,
    TextSelectionControls selectionControls,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    ValueChanged<String> onSubmitted,
    SelectionChangedCallback onSelectionChanged,
    List<TextInputFormatter> inputFormatters,
    bool rendererIgnoresPointer = false,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    bool cursorOpacityAnimates = false,
    Offset cursorOffset,
    bool paintCursorAboveText = false,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    Brightness keyboardAppearance = Brightness.light,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    bool enableInteractiveSelection,
    ScrollPhysics scrollPhysics,
  }) : super(
          key: key,
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          autocorrect: autocorrect,
          style: style,
          strutStyle: strutStyle,
          cursorColor: cursorColor,
          backgroundCursorColor: backgroundCursorColor,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          autofocus: autofocus,
          selectionColor: selectionColor,
          selectionControls: selectionControls,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          onSelectionChanged: onSelectionChanged,
          inputFormatters: inputFormatters,
          rendererIgnoresPointer: rendererIgnoresPointer,
          cursorWidth: cursorWidth,
          cursorRadius: cursorRadius,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          paintCursorAboveText: paintCursorAboveText,
          scrollPadding: scrollPadding,
          keyboardAppearance: keyboardAppearance,
          dragStartBehavior: dragStartBehavior,
          enableInteractiveSelection: enableInteractiveSelection,
          scrollPhysics: scrollPhysics,
        );

  @override
  EditableTextState createState() => MarkdownEditableTextState();
}

class MarkdownEditableTextState extends EditableTextState {
  TextEditingValue get _value => widget.controller.value;

  @override
  TextSpan buildTextSpan() {
    if (_value.composing.isValid) {
      final TextStyle composingStyle = widget.style.merge(
        const TextStyle(decoration: TextDecoration.underline),
      );

      return TextSpan(style: widget.style, children: <TextSpan>[
        MarkdownTextSpan(
          text: _value.composing.textBefore(_value.text),
          stripMarkdown: false,
        ),
        MarkdownTextSpan(
          style: composingStyle,
          text: _value.composing.textInside(_value.text),
          stripMarkdown: false,
        ),
        MarkdownTextSpan(
          text: _value.composing.textAfter(_value.text),
          stripMarkdown: false,
        ),
      ]);
    }

    String text = _value.text;
    return MarkdownTextSpan(
      style: widget.style,
      text: text,
      stripMarkdown: false,
    );
  }
}
