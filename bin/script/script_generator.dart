import 'dart:io';

import 'package:file/file.dart';
import 'package:meta/meta.dart';

import 'unix_script_generator.dart';

abstract class ScriptGenerator {
  factory ScriptGenerator.forPlatform() {
    if (Platform.isLinux) {
      return UnixScriptGenerator();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @protected
  ScriptGenerator();

  Future<void> writeStartScript(Directory path,
      String jarPath, String javaPath, List<String> additionalArgs);
}
