import 'package:interact/interact.dart';

import 'finder/jre_finder.dart';
import 'installer/adoptium/adoptium_jdk_installer.dart';
import 'jre_installation.dart';

const String _installPrompt = 'Install a new JRE';

Future<JreInstallation> choseJRE() async {
  var finder = JreFinder.forPlatform();
  var jres = await finder.findInstalledJres();

  var options = [
    ...jres.map((element) {
      return 'Java ${element.version.languageVersion} (${element.version.update}) in ${element.path}';
    }),
    _installPrompt
  ];

  var jreIndex =
      Select(prompt: 'Which java version do you want to use?', options: options)
          .interact();

  if (jreIndex == jres.length) {
    return _installJre();
  }

  return jres[jreIndex];
}

Future<JreInstallation> _installJre() async {
  var installer = AdoptiumJDKInstaller.forPlatform();
  var versions = await installer.retrieveVersions();

  var askVersion = Select(
      prompt: 'Which version do you want to install?',
      options: versions.map((e) => e.toString()).toList());
  var versionIndex = askVersion.interact();

  var version = versions[versionIndex];

  await installer.installVersion(version, installer.supportedVariants.first);

  return choseJRE();
}
