import 'dart:io';

import 'package:skynet/src/upload.dart';

class DirectoryUploadTask {
  Map<String, Stream<List<int>>> fileStreams = {};
  Map<String, int> lengths = {};

  String directoryPath;

  Future<String> uploadDir(String path) async {
    directoryPath = path;
    processDirectory(Directory(directoryPath));

    final skylink = await uploadDirectory(
      fileStreams,
      lengths,
      'wikilearn',
    );
    return skylink;
  }

  void processDirectory(Directory dir) {
    for (final entity in dir.listSync()) {
      if (entity is Directory) {
        processDirectory(entity);
      } else if (entity is File) {
        final file = entity;
        String path = file.path;

        path = path.substring(directoryPath.length);

        if (path.startsWith('/')) path = path.substring(1);

        print(path);

        lengths[path] = file.lengthSync();
        fileStreams[path] = file.openRead();
      }
    }
  }
}
