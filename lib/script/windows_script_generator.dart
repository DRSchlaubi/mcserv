import 'package:file/file.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/script/script_generator.dart';

class WindowsScriptGenerator extends ScriptGenerator {
  @override
  Future<void> writeStartScript(Directory path, String jarPath,
      JreInstallation java, List<String> additionalArgs) async {
    // OFC Microsoft called it 'Program Files'
    final sanitizedJavaPath =
        java.binary.contains(RegExp('\\s+')) ? '"${java.binary}"' : java.binary;

    final stringBuffer = StringBuffer();
    //language=bash
    stringBuffer.writeln('@echo off');

    stringBuffer.write(sanitizedJavaPath);
    stringBuffer.write('/bin/java.exe');

    if (additionalArgs.isNotEmpty) {
      stringBuffer.writeln(' ^');
      for (var arg in additionalArgs) {
        stringBuffer.writeln('$arg ^');
      }
    }

    stringBuffer.write(' -jar $jarPath nogui');

    final file = path.childFile('start.bat');
    await file.writeAsString(stringBuffer.toString());
  }
}
