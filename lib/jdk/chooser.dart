import 'package:interact/interact.dart';
import 'package:mcserve/utils/localizations_util.dart';

import 'finder/jre_finder.dart';
import 'installer/adoptium/adoptium_jdk_installer.dart';
import 'jre_installation.dart';

const String _installPrompt = 'Install a new JRE';

Future<JreInstallation> choseJRE() async {
  final finder = JreFinder.forPlatform();
  final jres = await finder.findInstalledJres();

  final options = [
    ...jres.map((element) {
      return localizations.javaInstallation(element.version.languageVersion,
          element.version.update, element.path);
    }),
    _installPrompt
  ];

  final jreIndex =
      Select(prompt: localizations.pickJavaInstallation, options: options)
          .interact();

  if (jreIndex == jres.length) {
    return _installJre();
  }

  return jres[jreIndex];
}

Future<JreInstallation> _installJre() async {
  final installer = AdoptiumJDKInstaller.forPlatform();
  final versions = await installer.retrieveVersions();

  final askVersion = Select(
      prompt: localizations.pickLanguageVersion,
      options: versions.map((e) => e.toString()).toList());
  final versionIndex = askVersion.interact();

  final version = versions[versionIndex];

  await installer.installVersion(version, installer.supportedVariants.first);

  return choseJRE();
}
