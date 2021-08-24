import 'package:mcserve/commands/command.dart';
import 'package:mcserve/distributions/distribution.dart';
import 'package:mcserve/mc_installer/mc_installer_helper.dart';
import 'package:mcserve/settings/server_chooser.dart';
import 'package:mcserve/settings/settings.dart';
import 'package:mcserve/settings/settings_helper.dart';
import 'package:mcserve/utils/utils.dart';

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get prompt => localizations.updateCommand;

  @override
  Future<void> execute() async {
    var server = await chooseServer();
    if (server == null) {
      return;
    }

    var distribution = Distribution.forName(server.distribution);
    var latestBuild = await distribution.retrieveLatestBuildFor(server.version);

    var directory = fs.directory(server.location);

    var version = server.version;

    if (server.build >= latestBuild) {
      print(localizations.alreadyOnLatestBuild);
      if (!confirm(localizations.upgradeVersion)) {
        return;
      }
      version = await distribution.askForVersion();
    }

    final build = await distribution.installServer(version, directory);

    var newInstallation =
        Installation(server.distribution, version, server.location, build);

    await updateServer(newInstallation);
  }
}
