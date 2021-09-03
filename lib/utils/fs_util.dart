import 'dart:io';

import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path_lib;

final _log = Logger('FsUtil');

const _fs = LocalFileSystem();

Directory findDirectory(String path) => _fs.directory(path.sanitizePath());

Directory findJoinedDirectory(Iterable<String> parts) =>
    findDirectory(path_lib.joinAll(parts));

File findFile(String path) => _fs.file(path.sanitizePath());

File findJoinedFile(Iterable<String> parts) =>
    findFile(path_lib.joinAll(parts));

extension PathSanitizer on String {
  String sanitizePath() {
    var sanitizedPath = this;
    if (startsWith('~')) {
      switch (Platform.operatingSystem) {
        case 'macos':
        case 'linux':
          final userHome = Platform.environment['HOME']!;
          sanitizedPath = path_lib.join(userHome, substring(2));
          break;
        case 'windows':
          final userHome = Platform.environment['UserProfile']!;
          sanitizedPath = path_lib.join(userHome, substring(2));
          break;
        default:
          throw UnsupportedError('Unsupported OS: ${Platform.operatingSystem}');
      }
    }
    if (sanitizedPath != this) {
      _log.finer('Sanitizing $this to $sanitizedPath');
    }

    final normalized = path_lib
        .absolute(path_lib.normalize(path_lib.canonicalize(sanitizedPath)));
    _log.finer('Normalizing $sanitizedPath to $normalized');

    return normalized;
  }
}
