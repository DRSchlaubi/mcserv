import 'dart:io';

import 'package:file/file.dart';
import 'package:path/path.dart' as path;

import '../jdk/installer/jdk_installer.dart';
import 'fs_util.dart';

Future<Directory> getMCServHome() async {
  final path = _getMCServHomePath();
  return _getOrCreate(path: path);
}

Future<Directory> getJDKDownloadCache() async {
  final home = await getMCServHome();
  final cache = home.childDirectory(JDKInstaller.cacheFolder);

  return _getOrCreate(directory: cache);
}

Future<Directory> getJDKFolder() async {
  final home = await getMCServHome();
  final jdks = home.childDirectory('jdks');

  return _getOrCreate(directory: jdks);
}

Future<Directory> _getOrCreate({String? path, Directory? directory}) async {
  final dir = (path != null ? fs.directory(path) : directory)!;
  if (!await dir.exists()) {
    await dir.create();
  }

  return dir;
}

String _getMCServHomePath() {
  switch (Platform.operatingSystem) {
    case 'macos':
    case 'linux':
      final userHome = Platform.environment['HOME']!;
      return path.join(userHome, '.mcserv');
    case 'windows':
      final userHome = Platform.environment['UserProfile']!;
      return path.join(userHome, 'AppData', 'Roaming', '.mcserv');
    default:
      throw UnsupportedError('Unsupported OS: ${Platform.operatingSystem}');
  }
}
