import 'package:file/file.dart';
import 'package:interact/interact.dart';
import 'package:mcserv/utils/localizations_util.dart';

import 'package:mcserv/distributions/distribution.dart';

extension McInstallerHelper on Distribution {
  Future<int> installServer(String version, Directory directory) async {
    print(localizations.downloadingDistro);
    return await downloadTo(version, directory.childFile('server.jar'));
  }

  Future<String> _askVersionGroup() async {
    if (!supportsVersionGroups) return 'internal_version_group';
    final versionsGroups = await retrieveVersionGroups();
    final ask = Select(
        prompt: localizations.chooseServerVersion, options: versionsGroups);
    final versionGroupIndex = ask.interact();
    return versionsGroups[versionGroupIndex];
  }

  Future<String> askForVersion() async {
    final versionGroup = await _askVersionGroup();

    final versions = (await retrieveVersions(versionGroup)).versions;
    if (versions.length > 1) {
      final versionAsk = Select(
          prompt: localizations.chooseServerSubVersion, options: versions);
      final versionIndex = versionAsk.interact();
      return versions[versionIndex];
    }
    return versions.first;
  }
}
