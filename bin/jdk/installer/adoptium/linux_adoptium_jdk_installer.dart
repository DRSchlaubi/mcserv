import 'dart:io';

import 'package:logging/logging.dart';

import 'adoptium_api.dart';
import 'adoptium_jdk_installer.dart';

final _log = Logger('LinuxAdoptiumJDKInstaller');

class LinuxAdoptiumJDKInstaller extends AdoptiumJDKInstaller {
  @override
  Future<void> installJre(AdoptiumBinary binary, File jre) async {
    final destination = fs.directory('/usr/lib/jvm');
    if (!await destination.exists()) {
      await destination.create();
    }
    _log.fine('Unpacking ${jre.path} to ${destination.path}');

    final result = await Process.run(
        'tar', ['-xzvf', jre.absolute.path, '-C', destination.path],
        runInShell: true);

    _log.fine('TAR responded with: ${result.exitCode} => ${result.stdout}');

    if (result.exitCode > 0) {
      _log.severe(
          'Could not untar JRE: ${result.exitCode} => ${result.stdout}');
    }

    await jre.delete();
  }
}
