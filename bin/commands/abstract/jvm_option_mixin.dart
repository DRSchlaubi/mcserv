import 'package:args/args.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/jdk/chooser.dart';
import 'package:mcserv/jdk/jre_installation.dart';
import 'package:mcserv/utils/fs_util.dart';

const jvmInstallOption = 'jvm';
const jvmVersionOption = 'jvm-version';

mixin JvmOption on Command {
  String get preselectedInstallation =>
      sanitizePath(argResults[jvmInstallOption]);

  int get preselectedJvmVersion => argResults[jvmVersionOption];

  ArgParser withJvmOption(ArgParser argParser) =>
      argParser..addOption(jvmVersionOption)..addOption(jvmInstallOption);

  Future<JreInstallation> askForJre({int? from, int? to}) => chooseJRE(
      from: from,
      to: to,
      preselectedPath: preselectedInstallation,
      preselectedInstallVersion: preselectedJvmVersion);
}
