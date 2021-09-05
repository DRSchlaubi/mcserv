import 'package:args/args.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/mc_installer/mc_installer_helper.dart';

mixin VersionOption on Command {
  String? get preselectedVersion => argResults[versionOption];

  ArgParser withVersionFlag(ArgParser argParser, String description) =>
      argParser
        ..addOption(versionOption, help: description, valueHelp: '1.17.1');

  Future<String?> askForVersion(Distribution distribution) =>
      distribution.askForVersion(predefined: preselectedVersion);
}
