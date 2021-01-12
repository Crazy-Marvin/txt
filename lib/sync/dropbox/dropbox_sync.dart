import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/widgets.dart';
import 'package:txt/sync/file.dart';
import 'package:txt/sync/sync.dart';

class DropboxSyncService extends SyncService {
  String token;

  @override
  Future<void> authorize(BuildContext context) async {
    // TODO store access token and try authenticating with access token first.
    await Dropbox.authorize();
    token = await Dropbox.getAccessToken();
  }

  @override
  Future<String> getAccountName() => Dropbox.getAccountName();

  @override
  Future<List<RemoteFile>> listFolder(String path) async {
    var files = await Dropbox.listFolder(path);
    throw UnimplementedError();
  }

  @override
  Future<void> download(String remotePath, String localPath) =>
      Dropbox.download(remotePath, localPath);

  @override
  Future<void> upload(String localPath, String remotePath) =>
      Dropbox.upload(localPath, remotePath);
}
