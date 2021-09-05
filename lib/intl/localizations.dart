import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'messages_all.dart';

class Localizations {
  final String localeName;

  Localizations(this.localeName);

  static Future<Localizations> load(Locale locale) {
    final name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return Localizations(localeName);
    });
  }

  // CLI arguments

  String get verboseLoggingHelp => Intl.message('Enables verbose logging',
      name: 'verboseLoggingHelp', locale: localeName);

  String get helpFlagHelp => Intl.message('Prints this help message',
      name: 'helpFlagHelp', locale: localeName);

  String get logLevelHelp => Intl.message('Sets the log level',
      name: 'logLevelHelp', locale: localeName);

  String get yesFlagDescription =>
      Intl.message('Answers all yes/no prompts with yes',
          name: 'yesFlagDescription', locale: localeName);

  String get serverOptionDescription =>
      Intl.message('The path to the server to delete',
          name: 'serverOptionDescription', locale: localeName);

  String get jvmPathOptionDescription =>
      Intl.message('Path to the Java installation to use',
          name: 'jvmPathOptionDescription', locale: localeName);

  String get jvmVersionOptionDescription =>
      Intl.message('Java version to install',
          name: 'jvmVersionOptionDescription', locale: localeName);

  // Commands

  String get pickCommand => Intl.message('What do you want to do?',
      name: 'pickCommand', locale: localeName);

  String get newCommand => Intl.message('Create a new server',
      name: 'newCommand', locale: localeName);

  String get deleteCommand => Intl.message('Delete a server',
      name: 'deleteCommand', locale: localeName);

  String get detectCommand => Intl.message('Add an existing server',
      name: 'detectCommand', locale: localeName);

  String get updateCommand => Intl.message('Update an existing Server',
      name: 'updateCommand', locale: localeName);

  String get updateCommandIndev =>
      Intl.message('This feature is currently in development',
          name: 'updateCommandIndev', locale: localeName);

  // new Command
  String get destinationDirectory => Intl.message('Destination Directory',
      name: 'destinationDirectory', locale: localeName);

  String get versionFlagDescriptionNew =>
      Intl.message('The MC version to install',
          name: 'versionFlagDescriptionNew', locale: localeName);

  String acceptEula(String eula) =>
      Intl.message('Do you accept the MC Eula? ($eula)',
          name: 'acceptEula', locale: localeName, args: [eula]);

  String get useAikarFlags =>
      Intl.message("Do you want to use Aikar's JVM flags?",
          name: 'useAikarFlags', locale: localeName);

  String get downloadingDistro => Intl.message('Downloading Distribution',
      name: 'downloadingDistro', locale: localeName);

  String get overwriteDestinationDirectory => Intl.message(
      'Specified directory does not exist, do you want to create it?',
      name: 'overwriteDestinationDirectory',
      locale: localeName);

  String get createDestinationDirectory => Intl.message(
      'The specified directory is not empty, do you want to proceed?',
      name: 'createDestinationDirectory',
      locale: localeName);

  String get chooseServerDistro => Intl.message('Chose Server Distribution',
      name: 'chooseServerDistro', locale: localeName);

  String get chooseServerVersion => Intl.message('Choose Server Version',
      name: 'chooseServerVersion', locale: localeName);

  String get chooseServerSubVersion => Intl.message('Choose Subversion',
      name: 'chooseServerSubVersion', locale: localeName);

  // delete command

  String get confirmDelete =>
      Intl.message('Do you really want to delete this server?',
          name: 'confirmDelete', locale: localeName);

  // update command
  String get alreadyOnLatestBuild =>
      Intl.message('You already have the latest build',
          name: 'alreadyOnLatestBuild', locale: localeName);

  String get versionFlagDescriptionUpdate =>
      Intl.message('The MC version to upgrade to',
          name: 'versionFlagDescriptionUpdate', locale: localeName);

  String get upgradeVersion =>
      Intl.message('Do you want to upgrade the version instead?',
          name: 'upgradeVersion', locale: localeName);

  // JDK Chooser
  String get pickJavaInstallation =>
      Intl.message('Which Java installation do you want to use?',
          name: 'pickJavaInstallation', locale: localeName);

  String javaInstallation(int languageVersion, int update, String path) =>
      Intl.message('Java $languageVersion ($update) at $path',
          name: 'javaInstallation', args: [languageVersion, update, path]);

  String noJavaInstallation(String at) =>
      Intl.message('There is no Java Installation at $at',
          name: 'noJavaInstallation', args: [at], locale: localeName);

  String get pickLanguageVersion =>
      Intl.message('Which version do you want to install?',
          name: 'pickLanguageVersion', locale: localeName);

  String get downloadingJava => Intl.message('Downloading Java',
      name: 'downloadingJava', locale: localeName);

  // Server chooser
  String get noServersYet => Intl.message("You don't have any servers yet",
      name: 'noServersYet', locale: localeName);

  String noServer(String at) => Intl.message('There is no server at $at',
      name: 'noServer', args: [at], locale: localeName);

  String get chooseServer =>
      Intl.message('Choose a server', name: 'chooseServer', locale: localeName);

  String serverInstallation(String distributionName, String version, int build,
          String location) =>
      Intl.message('$distributionName $version ($build) at $location',
          args: [distributionName, version, build, location],
          name: 'serverInstallation',
          locale: location);

  String versionNotSupported(String version, String distribution) =>
      Intl.message(
          'Version $version is not supported by distribution $distribution',
          name: 'versionNotSupported',
          args: [version, distribution],
          locale: localeName);

  // Installer
  String get overwriteExistingJava => Intl.message(
      'Selected JDK is already installed, do you want to overwrite it?',
      name: 'overwriteExistingJava',
      locale: localeName);

  // Downloader
  String get downloadDone =>
      Intl.message('Download finished, syncing changes to fs!',
          name: 'downloadDone', locale: localeName);

  // Misc
  String get recommended =>
      Intl.message('Recommended', name: 'recommended', locale: localeName);
}
