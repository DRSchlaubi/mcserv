import 'package:mcserv/commands/command.dart';
import 'package:mcserv/settings/server_chooser.dart';
import 'package:mcserv/settings/settings_helper.dart';
import 'package:mcserv/utils/utils.dart';

class DeleteCommand extends Command {
  @override
  String get name => 'delete';

  @override
  String get prompt => localizations.deleteCommand;

  @override
  Future<void> execute() async {
    var server = await chooseServer();
    if (server == null) {
      return;
    }

    if (confirm(localizations.confirmDelete, waitForNewLine: true)) {
      await fs.directory(server.location).delete(recursive: true);
      await removeServer(server.location);
    }
  }
}
