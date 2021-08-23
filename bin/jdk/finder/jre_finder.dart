import 'dart:io';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../jre_installation.dart';
import 'unix_jre_finder.dart';
import 'windows_jre_finder.dart';

//language=RegExp
final _javaVersionRegex = RegExp('version "([0-9_.]*)"');

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
  final log = Logger('JreFinder');

  Future<List<JreInstallation>> findInstalledJres() async {
    final javaHome = Platform.environment['JAVA_HOME'];
    final javaCommand = await runWhich('java');
    final additionalPaths = await produceAdditionalDirs();
    final paths = <String>{
      if (javaHome != null) javaHome,
      javaCommand,
      ...additionalPaths
    };

    final foundVersions = <JreInstallation>[];

    for (var element in paths) {
      final binary = element + '/bin/java';

      final version = await detectVersion(binary);
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

    final result = await Process.run(binary, ['-version']);
    String stdout = result.stdout;
    String output = stdout.isEmpty ? result.stderr : stdout;

    log.finer('Got response from java binary: $output');

    if (result.exitCode != 0) {
      log.severe('Got unexpected exit code: ${result.exitCode}: $output');
      return null;
    }

    final match = _javaVersionRegex.firstMatch(output);
    if (match == null) {
      log.severe('Could not parse java version output: $output');
      return null;
    }
    final version = match.group(1)!;
    if (version.startsWith('1.')) {
      // pre java 10 versioning
      final languageVersion = int.parse(version[2]); // 1.<version>
      final updateSeparator = version.indexOf('_');
      final update = int.parse(version.substring(updateSeparator + 1));

      return JreVersion(languageVersion, update);
    } else {
      // java 10+ versioning
      final languageVersion = int.parse(version.substring(0, 2)); // first 2 chars
      final lastVersionSeparator = version.lastIndexOf('.');
      final update = int.parse(version.substring(lastVersionSeparator + 1));

      return JreVersion(languageVersion, update);
    }
  }
}
