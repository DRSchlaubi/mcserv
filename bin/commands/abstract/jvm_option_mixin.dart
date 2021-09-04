import 'package:args/args.dart';
import 'package:mcserv/jdk/chooser.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/utils/utils.dart';

import 'yes_flag_mixin.dart';

const jvmInstallOption = 'jvm';
const jvmVersionOption = 'jvm-version';

mixin JvmOption on YesFlag {
  String? get preselectedInstallation =>
      (argResults[jvmInstallOption] as String?)?.sanitizePath();

  int? get preselectedJvmVersion =>
      (argResults[jvmVersionOption] as String?)?.tryParseToInt();

  ArgParser withJvmOption(ArgParser argParser) =>
      argParser..addOption(jvmVersionOption)..addOption(jvmInstallOption);

  Future<JreInstallation?> askForJre({int? from, int? to}) => chooseJRE(
      from: from,
      to: to,
      preselectedPath: preselectedInstallation,
      preselectedInstallVersion: preselectedJvmVersion,
      overrideExistingJdk: hasYesFlag,
      ignoreChecksum: hasYesFlag);
}
