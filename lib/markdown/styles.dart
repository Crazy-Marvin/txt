import 'package:flutter/material.dart';

class MarkdownSyntaxStyles {
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
  static final TextStyle syntax = TextStyle(color: Colors.black45);
}
