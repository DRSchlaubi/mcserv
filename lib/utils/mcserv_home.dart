import 'dart:io';

import 'package:file/file.dart';
import 'package:path/path.dart' as path;

import '../jdk/installer/jdk_installer.dart';
import 'fs_util.dart';

Future<Directory> getMCServHome() async {
  final path = _getMCServHomePath();
  return _getOrCreate(path: path);
}

Future<Directory> getJDKDownloadCache() => _homeChild(JDKInstaller.cacheFolder);

Future<Directory> getJDKFolder() => _homeChild('jdks');

Future<File> getServersFile() async {
  final home = await getMCServHome();
  final servers = home.childFile('servers.json');

  if (!await servers.exists()) {
    await servers.create();
  }

  return servers;
}

Future<Directory> _homeChild(String childPath) async {
  final home = await getMCServHome();
  final child = home.childDirectory(childPath);

  return _getOrCreate(directory: child);
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
