import 'dart:io';

import 'package:file/local.dart';

import '../../utils/process_util.dart';
import 'jre_finder.dart';

class UnixJreFinder extends JreFinder {
  @override
  Future<String> runWhich(String command) =>
      Process.run('which', [command]).then((value) => value.safeOutput.trim());

  @override
  Future<List<String>> produceAdditionalDirs() async {
    final jdks = <String>[];

    Future<void> addDirs(Directory dir) async {
      if (await dir.exists()) {
        jdks.addAll(await dir
            .list(followLinks: false)
            .map((event) => event.path)
            .toList());
      }
    }

    final fs = LocalFileSystem();
    final userHome = Platform.environment['HOME']!;
    final sdkManJava = fs.directory('$userHome/.sdkman/candidates/java/');
    final lib = fs.directory('/usr/lib/jvm');

    await addDirs(sdkManJava);
    await addDirs(lib);

    return jdks;
  }
}
