import 'dart:io';

import '../../utils/process_util.dart';
import 'jre_finder.dart';

class WindowsJreFinder extends JreFinder {
  @override
  Future<String> runWhich(String command) =>
      Process.run('where', [command]).then((value) => value.safeOutput);

  @override
  Future<List<String>> produceAdditionalDirs() async {
    return [];
  }
}
