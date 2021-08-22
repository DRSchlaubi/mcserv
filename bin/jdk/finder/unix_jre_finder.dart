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
    var fs = LocalFileSystem();
    var userHome = Platform.environment['HOME']!;
    var sdkManJava = fs.directory('$userHome/.sdkman/candidates/java/');
    if (await sdkManJava.exists()) {
      return sdkManJava
          .list(followLinks: false)
          .map((event) => event.path)
          .toList();
    }
    return [];
  }
}
