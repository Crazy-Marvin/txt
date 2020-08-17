import 'dart:io';

extension FileExtension on File {
  Future<File> createIfNotExists({bool recursive: false}) async {
    if (!await exists())
      return await create(recursive: recursive);
    else
      return this;
  }

  createIfNotExistsSync({bool recursive: false}) {
    if (!existsSync())
      return createSync(recursive: recursive);
    else
      return this;
  }
}

extension DirectoryExtension on Directory {
  Future<Directory> createIfNotExists({bool recursive: false}) async {
    if (!await exists())
      return await create(recursive: recursive);
    else
      return this;
  }

  createIfNotExistsSync({bool recursive: false}) {
    if (!existsSync())
      return createSync(recursive: recursive);
    else
      return this;
  }
}
