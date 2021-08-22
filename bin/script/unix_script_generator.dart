
import 'package:file/file.dart';
import 'package:logging/logging.dart';

import '../utils/chmod_lib.dart';
import 'script_generator.dart';

var _log = Logger('ScriptGenerator');

class UnixScriptGenerator extends ScriptGenerator {
  @override
  Future<void> writeStartScript(Directory path, String jarPath, String javaPath,
      List<String> additionalArgs) async {
    var stringBuffer = StringBuffer();
    //language=sh
    stringBuffer.writeln('#!/bin/sh');
    //language=sh
    stringBuffer.write('$javaPath');

    if (additionalArgs.isNotEmpty) {
      stringBuffer.writeln(' \\');
      additionalArgs.forEach((arg) {
        stringBuffer.writeln('$arg \\');
      });
    }

    stringBuffer.write(' -jar $jarPath nogui');

    var file = path.childFile('start.sh');
    await file.writeAsString(stringBuffer.toString());

    // See https://github.com/dart-lang/sdk/issues/15078 for native calls
    var exitCode = NativeLib.runChmod(file, 0x755);
    if (exitCode != 0) {
      _log.warning(
          'Could not modify script permissions: $exitCode');
    }
  }
}
