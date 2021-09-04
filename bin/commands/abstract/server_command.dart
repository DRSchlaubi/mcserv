import 'package:args/args.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/settings/server_chooser.dart';
import 'package:mcserv/settings/settings.dart';
import 'package:mcserv/utils/fs_util.dart';
import 'package:mcserv/utils/localizations_util.dart';
import 'package:meta/meta.dart';

abstract class ServerCommand extends Command {
  @override
  ArgParser get argParser => makeArgParser();

  @protected
  ArgParser makeArgParser() => ArgParser()
    ..addOption('server',
        abbr: 's',
        help: localizations.serverOptionDescription,
        valueHelp: '~/servers/server1');

  @mustCallSuper
  @override
  Future<void> execute() async {
    final server = await chooseServer(
        existingPath: (argResults['server'] as String?)?.sanitizePath());
    if (server == null) {
      return;
    }

    return runOnServer(server);
  }

  Future<void> runOnServer(Installation server);
}
