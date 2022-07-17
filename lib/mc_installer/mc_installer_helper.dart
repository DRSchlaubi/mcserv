import 'package:file/file.dart';
import 'package:interact/interact.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/utils/utils.dart';

const versionOption = 'server-version';

extension McInstallerHelper on Distribution {
  Future<int> installServer(String version, Directory directory,
      {bool ignoreChecksum = false}) async {
    print(localizations.downloadingDistro);
    return await downloadTo(
        version, directory.childFile('server.jar'), ignoreChecksum);
  }

  Future<String> _askVersionGroup(String? predefined) async {
    if (!supportsVersionGroups) return 'internal_version_group';
    if (predefined != null) {
      return predefined.substring(0, predefined.lastIndexOf('.'));
    }
    final versionsGroups = await retrieveVersionGroups()
        .then((groups) => groups.reversed.toList());
    if (versionsGroups.length == 1) {
      return versionsGroups[0];
    }
    final ask = Select(
        prompt: localizations.chooseServerVersion, options: versionsGroups);
    final versionGroupIndex = ask.interact();
    return versionsGroups[versionGroupIndex];
  }

  Future<String?> askForVersion({String? predefined}) async {
    final versionGroup = await _askVersionGroup(predefined);

    final versions = (await retrieveVersions(versionGroup)).versions.reversed.toList();
    if (predefined != null) {
      return versions.find((element) => element, predefined,
          errorMessage: () =>
              localizations.versionNotSupported(predefined, name));
    }
    if (versions.length > 1) {
      final versionAsk = Select(
          prompt: localizations.chooseServerSubVersion, options: versions);
      final versionIndex = versionAsk.interact();
      return versions[versionIndex];
    }
    return versions.first;
  }
}
