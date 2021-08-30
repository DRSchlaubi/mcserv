import 'package:file/src/interface/directory.dart';
import 'package:mcserv/script/script_generator.dart';

class WindowsScriptGenerator extends ScriptGenerator {
  @override
  Future<void> writeStartScript(Directory path, String jarPath, String javaPath,
      List<String> additionalArgs) async {

    // OFC Microsoft called it 'Program Files'
    final sanitizedJavaPath =
        javaPath.contains('\\s+') ? '"$javaPath"' : javaPath;

    final stringBuffer = StringBuffer();
    stringBuffer.write(sanitizedJavaPath);

    if (additionalArgs.isNotEmpty) {
      stringBuffer.writeln(' \^');
      additionalArgs.forEach((arg) {
        stringBuffer.writeln('$arg \^');
      });
    }

    stringBuffer.write(' -jar $jarPath nogui');

    final file = path.childFile('start.bat');
    await file.writeAsString(stringBuffer.toString());
  }
}
