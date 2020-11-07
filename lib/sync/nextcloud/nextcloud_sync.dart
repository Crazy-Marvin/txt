import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/nextcloud.dart' as nc;
import 'package:txt/sync/file.dart';
import 'package:txt/sync/sync.dart';

class NextcloudSyncService implements SyncService {
  NextCloudClient client;

  @override
  Future<void> authorize(BuildContext context) async {
    // TODO Show login GUI.
    client = NextCloudClient(
        "cloud.reimer.family", "test", "jx@Wf*FfLknD+F=,MpUXHi&~veKtKq:=");
    // TODO Test connection e.g. via user backend.
  }

  @override
  Future<String> getAccountName() async {
    nc.MetaData metadata = await client.users.getMetaData(client.username);
    return "${metadata.fullName} (${client.username})";
  }

  @override
  Future<List<RemoteFile>> listFolder(String path) async {
    List<WebDavFile> files = await client.webDav.ls(path);
    return files
        .map((file) => NextcloudRemoteFile(file))
        .toList(growable: false);
  }

  @override
  Future<void> download(String remotePath, String localPath) async {
    ByteStream downloadStream = await client.webDav.downloadStream(remotePath);
    File localFile = File(localPath);
    if (localFile.existsSync()) localFile.deleteSync();
    IOSink localSink = localFile.openWrite();
    await localSink.addStream(downloadStream);
    await localSink.close();
  }

  @override
  Future<void> upload(String localPath, String remotePath) async {
    File localFile = File(localPath);
    var localData = await localFile.readAsBytes();
    await client.webDav.upload(localData, remotePath);
  }
}

class NextcloudRemoteFile extends RemoteFile {
  final WebDavFile file;

  NextcloudRemoteFile(this.file);

  @override
  DateTime get createdDate => file.createdDate;

  @override
  bool get isDirectory => file.isDirectory;

  @override
  DateTime get lastModified => file.lastModified;

  @override
  String get path => file.path;

  @override
  int get size => file.size;
}
