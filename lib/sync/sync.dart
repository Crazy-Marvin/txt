import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:txt/sync/file.dart';

abstract class SyncService {
  Future<void> authorize(BuildContext context);

  Future<String> getAccountName();

  Future<List<RemoteFile>> listFolder(String path);

  Future<void> upload(String localPath, String remotePath);

  Future<void> download(String remotePath, String localPath);

  Future<void> sync(String localPath, String remotePath) async {
    // 1. Load recent sync state
    // 2. List local files
    // 3. List remote files
    // 4. Compare changes in local and remote file systems:
    // 4.1. Find local/remote created/deleted/modified files.
    // 4.2. Resolve conflicts.
    // 4.3. List files to download/upload.
    // 4.4. List local/remote files to delete.
    // 5. Download/upload from/to remote (in parallel).
    // 6. Delete files and remove stub directories.
    // 7. Store new sync state.

    // 1. Load recent sync state
    _SyncState lastState = await _SyncState.load();

    // 2. List local files
    Map<String, File> localFiles = await _listLocalFiles(localPath);
    Set<String> localPaths = localFiles.keys.toSet();

    // 3. List remote files
    Map<String, RemoteFile> remoteFiles = await _listRemoteFiles(remotePath);
    Set<String> remotePaths = remoteFiles.keys.toSet();

    // 4. Compare changes in local and remote file systems.

    // 4.1. Find local/remote created/deleted/modified files.
    Set<String> localCreated = localPaths.difference(lastState.paths);
    Set<String> localDeleted = lastState.paths.difference(localPaths);
    Set<String> localSamePath = lastState.paths.intersection(localPaths);
    Set<String> localModified = localSamePath.where((path) => localFiles[path]
        .lastModifiedSync()
        .isAfter(lastState
            .timestamp)); // TODO Use asynchronous lastModified() for parallel execution.
    Set<String> localUnchanged = localSamePath.difference(localModified);
    Set<String> remoteCreated = remotePaths.difference(lastState.paths);
    Set<String> remoteDeleted = lastState.paths.difference(remotePaths);
    Set<String> remoteSamePath = lastState.paths.intersection(remotePaths);
    Set<String> remoteModified = remoteSamePath.where(
        (path) => remoteFiles[path].lastModified.isAfter(lastState.timestamp));
    Set<String> remoteUnchanged = remoteSamePath.difference(remoteModified);

    // There are 16 possible combinations of local/remote changes:
    //  1. A local created file can be created remotely.
    //  2. A local created file cannot be deleted remotely.
    //  3. A local created file cannot be modified remotely.
    //  4. A local created file cannot be unchanged remotely.
    //  5. A local deleted file cannot be created remotely.
    //  6. A local deleted file can be deleted remotely.
    //  7. A local deleted file can be modified remotely.
    //  8. A local deleted file can be unchanged remotely.
    //  9. A local modified file cannot be created remotely.
    // 10. A local modified file can be deleted remotely.
    // 11. A local modified file can be modified remotely.
    // 12. A local modified file can be unchanged remotely.
    // 13. A local unchanged file cannot be created remotely.
    // 14. A local unchanged file can be deleted remotely.
    // 15. A local unchanged file can be modified remotely.
    // 16. A local unchanged file can be unchanged remotely.

    // Also there are the situations when a file is created
    // only on one file system but is not present at the other.
    // Though these two situations could be handled simply
    // by uploading or downloading the file:
    Set<String> localOnlyCreated = localCreated.difference(remoteCreated);
    Set<String> remoteOnlyCreated = remoteCreated.difference(localCreated);

    // 4.2. Resolve conflicts.
    // We can ignore impossible combinations (2,3,4,5,9,13) or combinations,
    // where local/remote changes are equivalent (6,16).

    // The remaining 8 combinations must be compared individually:
    //  1. Keep the last modified file.
    //  7. Download remote modified file.
    //  8. Delete remote file.
    // 10. Upload local modified file.
    // 11. Keep the last modified file.
    // 12. Upload local modified file.
    // 14. Delete local file.
    // 15. Download remote modified file.

    Set<String> localCreatedRemoteCreated =
        localCreated.intersection(remoteCreated);
    Set<String> localDeletedRemoteModified =
        localDeleted.intersection(remoteModified);
    Set<String> localDeletedRemoteUnchanged =
        localDeleted.intersection(remoteUnchanged);
    Set<String> localModifiedRemoteDeleted =
        localModified.intersection(remoteDeleted);
    Set<String> localModifiedRemoteModified =
        localModified.intersection(remoteModified);
    Set<String> localModifiedRemoteUnchanged =
        localModified.intersection(remoteUnchanged);
    Set<String> localUnchangedRemoteDeleted =
        localUnchanged.intersection(remoteDeleted);
    Set<String> localUnchangedRemoteModified =
        localUnchanged.intersection(remoteModified);

    // 4.3. List files to download/upload.
    Set<String> uploadPaths = {};
    uploadPaths.addAll(localOnlyCreated);
    Set<String> downloadPaths = {};
    downloadPaths.addAll(remoteOnlyCreated);

    // 4.4. List local/remote files to delete.
    Set<String> deleteLocalPaths = {};
    Set<String> deleteRemotePaths = {};

    // 5. Download/upload from/to remote (in parallel).
    await Future.wait([
      _uploadFiles(localPath, remotePath, uploadPaths),
      _downloadFiles(remotePath, localPath, downloadPaths)
    ]);

    // 6. Delete files and remove stub directories.
    // TODO Add method for deleting from cloud to interface.
    // TODO

    // 7. Store new sync state
    // TODO

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
    String localPath,
    String remotePath,
    Set<String> paths,
  ) async {
    for (String path in paths) {
      await upload(join(localPath, path), join(remotePath, path));
    }
  }

  Future<void> _downloadFiles(
    String remotePath,
    String localPath,
    Set<String> paths,
  ) async {
    for (String path in paths) {
      await download(join(remotePath, path), join(localPath, path));
    }
  }
}

class _SyncState {
  // Time of this synchronisation.
  @required
  DateTime timestamp;

  // Files present after this synchronisation / at this state.
  @required
  Set<String> paths;

  _SyncState(this.timestamp, this.paths);

  static const KEY_TIMESTAMP = "_SyncState.timestamp";
  static const KEY_FILE_PATHS = "_SyncState.filePaths";

  Future<void> save() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(KEY_TIMESTAMP, timestamp.millisecondsSinceEpoch);
    preferences.setStringList(KEY_FILE_PATHS, paths.toList(growable: false));
  }

  static Future<_SyncState> load() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey(KEY_TIMESTAMP) ||
        !preferences.containsKey(KEY_FILE_PATHS)) {
      return null;
    }

    DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(preferences.getInt(KEY_TIMESTAMP));
    Set<String> filePaths = preferences.getStringList(KEY_FILE_PATHS).toSet();
    return _SyncState(timestamp, filePaths);
  }
}
