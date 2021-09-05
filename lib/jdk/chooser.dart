import 'package:interact/interact.dart';
import 'package:mcserv/utils/utils.dart';

import 'finder/jre_finder.dart';
import 'installer/adoptium/adoptium_jdk_installer.dart';
import 'jre_installation.dart';

const String _installPrompt = 'Install a new JRE';

Future<JreInstallation?> chooseJRE(
    {int? from,
    int? to,
    String? preselectedPath,
    int? preselectedInstallVersion,
    bool ignoreChecksum = false,
    bool overrideExistingJdk = false}) async {
  final finder = JreFinder.forPlatform();
  final jres = (await finder.findInstalledJres()).filterJdks(from, to).toList();

  if (preselectedPath != null) {
    return jres.find((element) => element.path, preselectedPath,
        errorMessage: () => localizations.noJavaInstallation(preselectedPath));
  }
  if (preselectedInstallVersion != null) {
    return _installJre(from, to, preselectedInstallVersion, ignoreChecksum,
        overrideExistingJdk);
  }

  final options = [
    ...jres.map((element) {
      return recommend(
          localizations.javaInstallation(element.version.languageVersion,
              element.version.update, element.path),
          element.version.languageVersion == to);
    }),
    _installPrompt
  ];

  final jreIndex =
      Select(prompt: localizations.pickJavaInstallation, options: options)
          .interact();

  if (jreIndex == jres.length) {
    return _installJre(from, to, preselectedInstallVersion, ignoreChecksum,
        overrideExistingJdk);
  }

  return jres[jreIndex];
}

Future<JreInstallation?> _installJre(int? from, int? to, int? predefined,
    bool ignoreChecksum, bool overrideExistingJdk) async {
  final installer = AdoptiumJDKInstaller.forPlatform();
  final versions =
      (await installer.retrieveVersions()).filterJdks(from, to).toList();

  final int version;
  if (predefined != null) {
    if (versions.contains(predefined)) {
      version = predefined;
    } else {
      return null;
    }
  } else {
    final askVersion = Select(
        prompt: localizations.pickLanguageVersion,
        options:
            versions.map((e) => recommend(e.toString(), e == to)).toList());
    final versionIndex = askVersion.interact();

    version = versions[versionIndex];
  }

  return await installer.installVersion(version,
      installer.supportedVariants.first, overrideExistingJdk, ignoreChecksum);
}

extension FilterInstallations on Iterable<JreInstallation> {
  Iterable<JreInstallation> filterJdks(int? from, int? to) => where((element) =>
      element.version.languageVersion >= (from ?? 0) &&
      element.version.languageVersion <= (to ?? 100));
}

extension FilterJdks on List<int> {
  Iterable<int> filterJdks(int? from, int? to) =>
      where((element) => element >= (from ?? 0) && element <= (to ?? 100));
}
