import 'dart:io';

import 'package:mcserve/utils/utils.dart';
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
}
