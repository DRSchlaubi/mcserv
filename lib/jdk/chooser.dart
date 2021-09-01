import 'package:interact/interact.dart';
import 'package:mcserv/utils/localizations_util.dart';
import 'package:mcserv/utils/recommendation_util.dart';

import 'finder/jre_finder.dart';
import 'installer/adoptium/adoptium_jdk_installer.dart';
import 'jre_installation.dart';

const String _installPrompt = 'Install a new JRE';

Future<JreInstallation> choseJRE({int? from, int? to}) async {
  final finder = JreFinder.forPlatform();
  final jres = (await finder.findInstalledJres()).filterJdks(from, to).toList();

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
    return _installJre(from, to);
  }

  return jres[jreIndex];
}

Future<JreInstallation> _installJre(int? from, int? to) async {
  final installer = AdoptiumJDKInstaller.forPlatform();
  final versions =
      (await installer.retrieveVersions()).filterJdks(from, to).toList();

  final askVersion = Select(
      prompt: localizations.pickLanguageVersion,
      options: versions.map((e) => recommend(e.toString(), e == to)).toList());
  final versionIndex = askVersion.interact();

  final version = versions[versionIndex];

  await installer.installVersion(version, installer.supportedVariants.first);

  return choseJRE(from: from, to: to);
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
