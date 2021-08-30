import 'dart:io';

import 'package:mcserv/utils/utils.dart';
import 'package:path/path.dart' as path;

import 'jre_finder.dart';

class UnixJreFinder extends JreFinder {
  @override
  Future<String> runWhich(String command) =>
      Process.run('which', [command]).then((value) => value.safeOutput.trim());

  @override
  Future<List<String>> produceAdditionalDirs() async {
    final userHome = Platform.environment['HOME']!;
    final sdkManJava = fs.directory('$userHome/.sdkman/candidates/java/');
    final lib = fs.directory('/usr/lib/jvm');

    final sdkManJres = await scanDir(sdkManJava);
    final linuxJres = await scanDir(lib);

    return [...sdkManJres, ...linuxJres];
  }

  @override
  String findBinary(String javaHome) => path.join(javaHome, 'bin', 'java');
}
