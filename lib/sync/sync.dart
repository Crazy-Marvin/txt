import 'package:flutter/widgets.dart';
import 'package:txt/sync/file.dart';

abstract class SyncService {
  Future<void> authorize(BuildContext context);

  Future<String> getAccountName();

  Future<List<RemoteFile>> listFolder(String path);

  Future<void> upload(String localPath, String remotePath);

  Future<void> download(String remotePath, String localPath);
}

Future<void> sync(String localPath, String remotePath) async {
  throw UnimplementedError();
}
