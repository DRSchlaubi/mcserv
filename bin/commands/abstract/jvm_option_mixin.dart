import 'dart:io';

import 'package:args/args.dart';
import 'package:mcserv/jdk/chooser.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/utils/utils.dart';

import 'yes_flag_mixin.dart';

const jvmInstallOption = 'jvm';
const jvmVersionOption = 'jvm-version';

String _exampleJre() {
  if (Platform.isWindows) {
    return 'C:\\Program Files\\Java\\jdk-16.0.2.7';
  } else if (Platform.isLinux) {
    return '/usr/lib/jvm/jdk-16.0.2.7';
  } else if (Platform.isMacOS) {
    return '/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home';
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}

mixin JvmOption on YesFlag {
  String? get preselectedInstallation =>
      (argResults[jvmInstallOption] as String?)?.sanitizePath();

  int? get preselectedJvmVersion =>
      (argResults[jvmVersionOption] as String?)?.tryParseToInt();

  ArgParser withJvmOption(ArgParser argParser) => argParser
    ..addOption(jvmVersionOption,
        help: localizations.jvmVersionOptionDescription, valueHelp: '16')
    ..addOption(jvmInstallOption,
        help: localizations.jvmPathOptionDescription, valueHelp: _exampleJre());

  Future<JreInstallation?> askForJre({int? from, int? to}) => chooseJRE(
      from: from,
      to: to,
      preselectedPath: preselectedInstallation,
      preselectedInstallVersion: preselectedJvmVersion,
      overrideExistingJdk: hasYesFlag,
      ignoreChecksum: hasYesFlag);
}
