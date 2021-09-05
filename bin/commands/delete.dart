import 'package:args/args.dart';
import 'package:mcserv/settings/settings.dart';
import 'package:mcserv/settings/settings_helper.dart';
import 'package:mcserv/utils/utils.dart';

import 'abstract/server_command.dart';
import 'abstract/yes_flag_mixin.dart';

class DeleteCommand extends ServerCommand with YesFlag {
  @override
  String get name => 'delete';

  @override
  String get prompt => localizations.deleteCommand;

  @override
  String get description => 'Deletes an existing Server!';

  @override
  ArgParser get argParser => withYesFlag(makeArgParser());

  @override
  Future<void> runOnServer(Installation server) async {
    if (globalConfirm(localizations.confirmDelete, waitForNewLine: true)) {
      await findDirectory(server.location).delete(recursive: true);
      await removeServer(server.location);
    }
  }
}
