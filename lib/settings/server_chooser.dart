import 'package:interact/interact.dart';
import 'package:mcserv/utils/localizations_util.dart';

import 'package:mcserv/distributions/distribution.dart';
import 'settings.dart';
import 'settings_loader.dart';

Future<Installation?> chooseServer({String? existingPath}) async {
  var settings = await loadSettings();
  var servers = settings.installations;

  if (servers.isEmpty) {
    print(localizations.noServersYet);
    return null;
  }

  if (existingPath != null) {
    return servers.firstWhere((element) => element.location == existingPath);
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
