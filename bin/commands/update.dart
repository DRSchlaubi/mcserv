import 'package:logging/logging.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/metadata/distribution_api.dart';
import 'package:mcserv/distributions/plain/plain_distribution.dart';
import 'package:mcserv/jdk/chooser.dart';
import 'package:mcserv/mc_installer/mc_installer_helper.dart';
import 'package:mcserv/script/script_generator.dart';
import 'package:mcserv/settings/server_chooser.dart';
import 'package:mcserv/settings/settings.dart';
import 'package:mcserv/settings/settings_helper.dart';
import 'package:mcserv/utils/constants.dart';
import 'package:mcserv/utils/utils.dart';

var _log = Logger('UpdateCommand');

class UpdateCommand extends Command {
  final _metadata = DistributionMetaDataApi(makeDio(_log));

  @override
  String get name => 'update';

  @override
  String get prompt => localizations.updateCommand;

  @override
  Future<void> execute() async {
    final server = await chooseServer();
    if (server == null) {
      return;
    }

    final distribution = Distribution.forName(server.distribution);
    final latestBuild =
        await distribution.retrieveLatestBuildFor(server.version);

    final meta = distribution.hasMetadata
        ? (await _metadata.getDistributionMetaData(distribution.name))
        : null;
    var installedVersion = meta?.versions
        .firstWhere((element) => element.version == server.version);

    final directory = fs.directory(server.location);

    var version = server.version;
    var reinstall = false;
    var newVersion = installedVersion;
    if (server.build >= latestBuild &&
        latestBuild != PlainDistribution.plainVersionBuild) {
      print(localizations.alreadyOnLatestBuild);
      if (!confirm(localizations.upgradeVersion)) {
        return;
      }
      reinstall = true;
      version = await distribution.askForVersion();
      newVersion =
          meta?.versions.firstWhere((element) => element.version == version);
    }

    if (reinstall) {
      _log.warning(
          'This will reinstall the server, starting the new server might corrupt world data');
      var jre = server.javaPath;
      if ((newVersion?.javaOptions.min ?? -1) > server.javaVersion) {
        print(
            'This version requires a newer version of Java. Please select or install a sufficient version');
        jre = (await choseJRE(
                from: newVersion?.javaOptions.min,
                to: newVersion?.javaOptions.max))
            .path;
      }

      final generator = ScriptGenerator.forPlatform();
      final destination = fs.directory(server.location);

      // ignore: omit_local_variable_types
      final List<String> flags = server.useFlags
          ? (meta?.flags[newVersion?.recommendedFlagKey] ?? [])
          : [];
      await generator.writeStartScript(destination, jarName, jre, flags);
    }

    final build = await distribution.installServer(version, directory);
    final newInstallation = Installation(
        server.distribution,
        version,
        server.location,
        build,
        server.javaVersion,
        server.javaPath,
        server.useFlags);

    await updateServer(newInstallation);
  }
}
