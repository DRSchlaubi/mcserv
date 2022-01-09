import 'dart:io';

import 'package:file/file.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/script/windows_script_generator.dart';
import 'package:meta/meta.dart';

import 'unix_script_generator.dart';

abstract class ScriptGenerator {
  factory ScriptGenerator.forPlatform() {
    if (Platform.isLinux) {
      return UnixScriptGenerator();
    } else if (Platform.isWindows) {
      return WindowsScriptGenerator();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @protected
  ScriptGenerator();

  Future<void> writeStartScript(Directory path, String jarPath,
      JreInstallation java, List<String> additionalArgs);
}
