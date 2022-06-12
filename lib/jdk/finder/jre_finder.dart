import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/utils/fs_util.dart';
import 'package:mcserv/utils/mcserv_home.dart';
import 'package:meta/meta.dart';

import 'unix_jre_finder.dart';
import 'windows_jre_finder.dart';

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
    final mcservJres = await scanDir(await getJDKFolder());

    final paths = <String>{
      if (javaHome != null) javaHome,
      javaCommand,
      ...mcservJres,
      ...additionalPaths
    };

    final foundVersions = <JreInstallation>[];

    for (var element in paths) {
      if (await FileSystemEntity.isLink(element)) {
        continue;
      }
      final javaHome = element.trim();
      final binary = findBinary(javaHome);
      final version = await detectVersion(binary);
      if (version != null) {
        foundVersions.add(JreInstallation(version, javaHome));
      }
    }

    return foundVersions.toSet().toList(); // distinct()
  }

  String findBinary(String javaHome);

  @protected
  Future<List<String>> scanDir(Directory dir) async {
    if (await dir.exists()) {
      return await dir
          .list(followLinks: false)
          .map((event) => event.path)
          .toList();
    }
    return [];
  }

  Future<List<String>> produceAdditionalDirs();

  Future<String> runWhich(String command);

  @protected
  Future<JreVersion?> detectVersion(String binary) async {
    log.fine('Inspecting possible java binary: $binary');
    if (!await findFile(binary).exists()) {
      log.finer("Binary '$binary' doesn't exist");

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

    return JreVersion.tryParse(output);
  }
}
