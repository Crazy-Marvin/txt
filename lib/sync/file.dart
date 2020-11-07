import 'package:flutter/cupertino.dart';

abstract class RemoteFile {
  /// File path.
  @required
  String path;

  /// File content length or folder size
  @required
  int size;

  // Date of last modification.
  @required
  DateTime lastModified;

  /// Creation date of the file.
  @required
  DateTime createdDate;

  /// Returns the decoded name of the file / folder without the whole path
  @required
  String get name {
    // normalised path (remove trailing slash)
    final end = path.endsWith('/') ? path.length - 1 : path.length;
    return Uri.parse(path, 0, end).pathSegments.last;
  }

  /// Whether the file is a directory.
  @required
  bool isDirectory;
}
