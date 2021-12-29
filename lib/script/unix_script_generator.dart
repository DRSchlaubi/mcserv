import 'package:file/file.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/utils/platform_utils/platform_utils.dart';

import 'script_generator.dart';

final _log = Logger('ScriptGenerator');

class UnixScriptGenerator extends ScriptGenerator {
  @override
  Future<void> writeStartScript(Directory path, String jarPath, String javaPath,
      List<String> additionalArgs) async {
    final stringBuffer = StringBuffer();
    //language=sh
    stringBuffer.writeln('#!/usr/bin/env sh');
    //language=sh
    stringBuffer.write(javaPath);
    stringBuffer.write('/bin/java');

    if (additionalArgs.isNotEmpty) {
      stringBuffer.writeln(' \\');
      for (var arg in additionalArgs) {
        stringBuffer.writeln('$arg \\');
      }
    }

    stringBuffer.write(' -jar $jarPath nogui');

    final file = path.childFile('start.sh');
    await file.writeAsString(stringBuffer.toString());

    // See https://github.com/dart-lang/sdk/issues/15078 for native calls
    final exitCode = NativeLib.runChmod(file, 0x755);
    if (exitCode != 0) {
      _log.warning('Could not modify script permissions: $exitCode');
    }
  }
}
