import 'dart:io';

import 'package:mcserv/utils/fs_util.dart';
import 'package:path/path.dart' as path;

import '../../utils/process_util.dart';
import 'jre_finder.dart';

class WindowsJreFinder extends JreFinder {
  @override
  Future<String> runWhich(String command) =>
      Process.run('where', [command]).then((value) => value.safeOutput);

  @override
  Future<List<String>> produceAdditionalDirs() async {
    final userHome = Platform.environment['UserProfile']!;

    final oracleBinaries =
        await scanDir(findDirectory('C:\\Program Files\\Java'));
    final adoptOpenJdkBinaries =
        await scanDir(findDirectory('C:\\Program Files\\AdoptOpenJDK'));
    final adoptiumBinaries =
        await scanDir(findDirectory('C:\\Program Files\\Eclipse Foundation'));
    final intelliJBinaries =
        await scanDir(findJoinedDirectory([userHome, '.jdks']));

    return [
      ...oracleBinaries,
      ...adoptOpenJdkBinaries,
      ...adoptiumBinaries,
      ...intelliJBinaries
    ];
  }

  @override
  String findBinary(String javaHome) => path.join(javaHome, 'bin', 'java.exe');
}
