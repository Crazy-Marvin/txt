import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:path/path.dart';
import 'package:txt/markdown/renderer.dart';
import 'package:txt/util/string_extension.dart';
import 'package:yaml/yaml.dart';

enum NoteType { Txt, Md }

enum NoteState { Normal, Archived, Trashed }

enum NoteSort { Title, LastModified }

@immutable
class NoteSettings {
  final NoteState state;
  final Set<String> tags;

  NoteSettings(this.state, this.tags);

  factory NoteSettings.fromYaml(String yaml) {
    final YamlMap settings = loadYamlNode(yaml);
    final bool trashed = settings.nodes["trashed"].value;
    final bool archived = settings.nodes["archived"].value;
    final NoteState state = trashed
        ? NoteState.Trashed
        : archived
        ? NoteState.Archived
        : NoteState.Normal;
    final YamlNode dynamicTags = settings.nodes["tags"];
    Set<String> tags = {};
    if (dynamicTags is YamlList) {
      tags = dynamicTags.nodes.map((tag) => tag.value.toString()).toSet();
    }
    return NoteSettings(state, tags);
  }

  String toYaml() {
    Map<String, dynamic> settings = {
      "trashed": state == NoteState.Trashed,
      "archived": state == NoteState.Archived,
      "tags": tags.toList(growable: false)
    };
    return json2yaml(settings);
  }
}

/// Represents a note file.
@immutable
class Note {
  final File file;

  Note(this.file);

  NoteType get type {
    switch (extension(file.path)) {
      case ".md":
        return NoteType.Md;
      case ".txt":
      default:
        return NoteType.Txt;
    }
  }

  static const String _frontMatterSeparator = "---";

  Future<String> get _frontMatter async {
    if (!await _lines.contains(_frontMatterSeparator)) return "";
    return await _lines
        .takeWhile((line) => line != _frontMatterSeparator)
        .join("\n");
  }

  Future<NoteSettings> get _settings async {
    return NoteSettings.fromYaml(await _frontMatter);
  }

  Future<NoteState> get state async => (await _settings).state;

  Future<Set<String>> get tags async => (await _settings).tags;

  String get title {
    return basenameWithoutExtension(file.path).capitalize();
  }

  Stream<List<int>> get _stream => file.openRead();

  Stream<String> get _lines =>
      _stream.transform(Utf8Decoder()).transform(LineSplitter());

  Future<String> get excerpt async {
    final bool hasFrontMatter = await _lines.contains(_frontMatterSeparator);
    Stream<String> lines = _lines;
    if (hasFrontMatter) {
      lines = lines.skipWhile((line) => line != _frontMatterSeparator).skip(1);
    }
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
