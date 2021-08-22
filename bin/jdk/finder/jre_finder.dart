import 'dart:io';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../jre_installation.dart';
import 'unix_jre_finder.dart';
import 'windows_jre_finder.dart';

//language=RegExp
var _javaVersionRegex = RegExp('version "([0-9_.]*)"');

abstract class JreFinder {
  factory JreFinder.forPlatform() {
    if (Platform.isLinux) {
      return UnixJreFinder();
    } else if (Platform.isWindows) {
      return WindowsJreFinder();
    } else {
      throw UnsupportedError('Unsupported platform!');
    }
  }

  @protected
  JreFinder();

  @protected
  var log = Logger('JreFinder');

  Future<List<JreInstallation>> findInstalledJres() async {
    var javaHome = Platform.environment['JAVA_HOME'];
    var javaCommand = await runWhich('java');
    var additionalPaths = await produceAdditionalDirs();
    var paths = <String>{
      if (javaHome != null) javaHome,
      javaCommand,
      ...additionalPaths
    };

    var foundVersions = <JreInstallation>[];

    for (var element in paths) {
      var binary = element + '/bin/java';

      var version = await detectVersion(binary);
      if (version != null) {
        foundVersions.add(JreInstallation(version, binary));
      }
    }

    return foundVersions;
  }

  Future<List<String>> produceAdditionalDirs();

  Future<String> runWhich(String command);

  @protected
  Future<JreVersion?> detectVersion(String binary) async {
    log.fine('Inspecting possible java binary: $binary');
    if (!await File(binary).exists()) {
      return null;
    }

    var result = await Process.run(binary, ['-version']);
    String stdout = result.stdout;
    String output = stdout.isEmpty ? result.stderr : stdout;

    log.finer('Got response from java binary: $output');

    if (result.exitCode != 0) {
      log.severe('Got unexpected exit code: ${result.exitCode}: $output');
      return null;
    }

    var match = _javaVersionRegex.firstMatch(output);
    if (match == null) {
      log.severe('Could not parse java version output: $output');
      return null;
    }
    var version = match.group(1)!;
    if (version.startsWith('1.')) {
      // pre java 10 versioning
      var languageVersion = int.parse(version[2]); // 1.<version>
      var updateSeparator = version.indexOf('_');
      var update = int.parse(version.substring(updateSeparator + 1));

      return JreVersion(languageVersion, update);
    } else {
      // java 10+ versioning
      var languageVersion = int.parse(version.substring(0, 2)); // first 2 chars
      var lastVersionSeparator = version.lastIndexOf('.');
      var update = int.parse(version.substring(lastVersionSeparator + 1));

      return JreVersion(languageVersion, update);
    }
  }
}
