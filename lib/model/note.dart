import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart';
import 'package:txt/markdown/renderer.dart';
import 'package:txt/util/string_extension.dart';

enum NoteType { Txt, Md }

enum NoteState { Normal, Archived, Trashed }

enum NoteSort { Title, LastModified }

@immutable
/// Represents a note file.
///
/// The file name is always in the form `<title>.<tags>.<state>.<extension>`.
class Note {
  final File file;
  final List<String> _basenameParts;

  static const String _basenameSeparator = ".";
  static const String _tagSeparator = " ";

  Note(this.file)
      : _basenameParts = basename(file.path).split(_basenameSeparator);

  String _lastBasenamePart(int index) =>
      _basenameParts[_basenameParts.length - 1 - index];

  NoteType get type {
    var extension = _lastBasenamePart(0);
    switch (extension) {
      case "md":
        return NoteType.Md;
      case "txt":
      default:
        return NoteType.Txt;
    }
  }

  NoteState get state {
    var state = _lastBasenamePart(1);
    switch (state) {
      case "trash":
        return NoteState.Trashed;
      case "archive":
        return NoteState.Archived;
      case "normal":
      default:
        return NoteState.Normal;
    }
  }

  List<String> get tags {
    var tags = _lastBasenamePart(2);
    if (tags == "") return [];
    return _lastBasenamePart(2)
        .split(" ")
        .map((tag) => tag.capitalize())
        .toList();
  }

  String get title {
//    return _basenameParts.first;
    return _basenameParts
        .sublist(0, _basenameParts.length - 3)
        .join(_basenameSeparator)
        .capitalize();
  }

  Stream<List<int>> get _stream => file.openRead();

  Future<String> get excerpt async {
    Stream<String> lines =
        _stream.transform(Utf8Decoder()).transform(LineSplitter());
    switch (type) {
      case NoteType.Txt:
        break;
      case NoteType.Md:
        List<String> markdownLines = await lines.toList();
        md.Document document = md.Document(
          extensionSet: md.ExtensionSet.gitHubWeb,
        );
        List<md.Node> nodes = document.parseLines(markdownLines);
        String text = StripMarkdownRenderer().render(nodes);
        lines = Stream.fromIterable(LineSplitter.split(text));
        break;
    }
    lines = lines.where((line) => line.isNotEmpty);
    List<String> lineList = await lines.take(3).toList();
    if (lineList.isEmpty) {
      return "";
    } else {
      return lineList.join(" ");
    }
  }

  Future<String> get content async => file.readAsString();
}
