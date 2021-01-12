import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:txt/sync/file.dart';

abstract class SyncService {
  Future<void> authorize(BuildContext context);

  Future<String> getAccountName();

  Future<List<RemoteFile>> listFolder(String path);

  Future<void> upload(String localPath, String remotePath);

  Future<void> download(String remotePath, String localPath);

  Future<void> sync(String localPath, String remotePath) async {
    // 1. List local files
    // 2. List remote files
    // 3. Compare:
    // 3.1. Find files that don't exist locally -> Download
    // 3.1. Find files that don't exist remotely -> Upload
    // 3.1. Compare other files -> Keep newest (backup old)
    // 4. Download/upload from/to remote (in parallel).
    // 5. Remove stub directories.

    // 1. List local files
    Map<String, File> localFiles = await _listLocalFiles(localPath);
    Set<String> localPaths = localFiles.keys.toSet();
    // 2. List remote files
    Map<String, RemoteFile> remoteFiles = await _listRemoteFiles(remotePath);
    Set<String> remotePaths = remoteFiles.keys.toSet();
    // 3. Compare.
    Set<String> conflictPaths = localPaths.intersection(remotePaths);
    Set<String> uploadPaths = localPaths.difference(conflictPaths);
    Set<String> downloadPaths = remotePaths.difference(conflictPaths);

    // 4. Download/upload from/to remote (in parallel).
    await Future.wait([
      _uploadFiles(localPath, remotePath, uploadPaths),
      _downloadFiles(remotePath, localPath, downloadPaths)
    ]);
    // 5. Remove stub directories.

    throw UnimplementedError();
  }

  Future<Map<String, File>> _listLocalFiles(String localPath) async {
    List<FileSystemEntity> files = await Directory(localPath)
        .list(recursive: true)
        .where((entity) => entity is File)
        .toList();
    return Map.fromIterable(files,
        key: (file) {
          String path = normalize(relative(file.path, from: localPath));
          return path;
        },
        value: (file) => file); // TODO normalize paths.
  }

  Future<Map<String, RemoteFile>> _listRemoteFiles(String remotePath) async {
    Queue<String> queue = Queue.of([remotePath]);
    Map<String, RemoteFile> files = {};
    while (queue.isNotEmpty) {
      String path = queue.removeFirst();
      List<RemoteFile> children = await listFolder(path);
      for (RemoteFile entry in children) {
        if (entry.isDirectory) {
          queue.add(entry.path);
        } else {
          String path = normalize(relative(entry.path, from: remotePath));
          files[path] = entry;
        }
      }
    }
    return files;
  }

  Future<void> _uploadFiles(
      String localPath, String remotePath, Set<String> paths) async {
    for (String path in paths) {
      await upload(join(localPath, path), join(remotePath, path));
    }
  }

  Future<void> _downloadFiles(
      String remotePath, String localPath, Set<String> paths) async {
    for (String path in paths) {
      await download(join(remotePath, path), join(localPath, path));
    }
  }
}
