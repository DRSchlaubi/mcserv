import 'package:interact/interact.dart';
import 'package:mcserve/utils/localizations_util.dart';

import 'package:mcserve/distributions/distribution.dart';
import 'settings.dart';
import 'settings_loader.dart';

Future<Installation?> chooseServer() async {
  var settings = await loadSettings();
  var servers = settings.installations;

  if (servers.isEmpty) {
    print(localizations.noServersYet);
    return null;
  }

  var ask = Select(
      prompt: localizations.chooseServer,
      options: servers.map((e) {
        var distribution = Distribution.forName(e.distribution);

        return localizations.serverInstallation(
            distribution.displayName, e.version, e.build, e.location);
      }).toList());

  var serverIndex = ask.interact();
  return servers[serverIndex];
}
