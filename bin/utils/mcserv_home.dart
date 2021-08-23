import 'dart:io';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path/path.dart' as path;

Future<Directory> getMCServHome() async {
  var path = _getMCServHomePath();
  var directory = LocalFileSystem().directory(path);
  if(!await directory.exists()) {
    await directory.create();
  }

  return directory;
}
String _getMCServHomePath() {
  switch (Platform.operatingSystem) {
    case 'macos':
    case 'linux':
      var userHome = Platform.environment['HOME']!;
      return path.join(userHome, '.mcserv');
    case 'windows':
      var userHome = Platform.environment['UserProfile']!;
      return path.join(userHome, 'AppData', 'Roaming', '.mcserv');
    default:
      throw UnsupportedError('Unsupported OS: ${Platform.operatingSystem}');
  }
}
