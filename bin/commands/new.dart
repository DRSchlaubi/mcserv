import 'package:args/args.dart';
import 'package:file/file.dart';
import 'package:interact/interact.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/metadata/distribution_api.dart';
import 'package:mcserv/mc_installer/mc_installer_helper.dart';
import 'package:mcserv/script/script_generator.dart';
import 'package:mcserv/settings/settings.dart';
import 'package:mcserv/settings/settings_helper.dart';
import 'package:mcserv/utils/constants.dart';
import 'package:mcserv/utils/recommendation_util.dart';
import 'package:mcserv/utils/utils.dart';

import 'abstract/jvm_option_mixin.dart';
import 'abstract/version_option_mixin.dart';
import 'abstract/yes_flag_mixin.dart';

const String _mcEula = 'https://account.mojang.com/documents/minecraft_eula';
const String _acceptEula = 'accept-eula';
const String _distribution = 'distribution';
const String _destination = 'destination';

var _log = Logger('NewCommand');

class NewCommand extends Command with YesFlag, JvmOption, VersionOption {
  final _metadata = DistributionMetaDataApi(makeDio(_log));

  @override
  String get description => 'Creates a new server installation';

  @override
  String get prompt => localizations.newCommand;

  @override
  String get name => 'new';

  @override
  ArgParser get argParser => withJvmOption(withVersionFlag(
      withYesFlag(ArgParser()), localizations.versionFlagDescriptionNew))
    ..addFlag(_acceptEula)
    ..addOption(_distribution, abbr: 'd', allowed: Distribution.names)
    ..addOption(_destination, abbr: 'D');

  @override
  Future<void> execute() async {
    final directory = await _askDirectory();
    final distribution = _askDistribution();
    final acceptEula = distribution.requiresEula
        ? confirm(localizations.acceptEula(_mcEula),
            defaultValue: true, predefined: argResults[_acceptEula])
        : false;

    final version = await askForVersion(distribution);
    if (version == null) {
      return;
    }

    final meta = distribution.hasMetadata
        ? (await _metadata.getDistributionMetaData(distribution.name))
        : null;
    final versionMeta =
        meta?.versions.firstWhere((element) => element.version == version);
    final useRecommendedFlags = versionMeta?.recommendedFlagKey != null
        ? globalConfirm(localizations.useAikarFlags, defaultValue: true)
        : false;

    final jre = await askForJre(
        from: versionMeta?.javaOptions.min, to: versionMeta?.javaOptions.max);
    if (jre == null) {
      return;
    }

    final build = await distribution.installServer(version, directory,
        ignoreChecksum: hasYesFlag);
    final status = Spinner(
        icon: Theme.defaultTheme.successPrefix,
        rightPrompt: (done) =>
            done ? 'Finalizing installation' : 'Installation done').interact();
    final scriptGen = ScriptGenerator.forPlatform();

    await scriptGen.writeStartScript(directory, jarName, jre.path, [
      if (useRecommendedFlags) ...meta!.flags[versionMeta!.recommendedFlagKey]!
    ]);

    if (acceptEula) {
      final eula = directory.childFile('eula.txt');
      await eula.writeAsString('eula=true');
    }

    await addServer(Installation(
        distribution.name,
        version,
        directory.absolute.path,
        build,
        jre.version.languageVersion,
        jre.path,
        useRecommendedFlags));

    status.done();
  }

  Future<Directory> _askDirectory() async {
    final String path;
    final predefined = argResults[_destination];
    if (predefined != null) {
      path = predefined;
    } else {
      final ask = Input(prompt: localizations.destinationDirectory);

      path = ask.interact();
    }
    final directory = findDirectory(path);

    if (!await directory.exists()) {
      if (!globalConfirm(localizations.overwriteDestinationDirectory)) {
        return _askDirectory();
      }

      await directory.create(recursive: true);
    }

    if (!(await directory.list().isEmpty)) {
      if (!globalConfirm(localizations.createDestinationDirectory)) {
        return _askDirectory();
      }
    }

    return directory;
  }

  Distribution _askDistribution() {
    if (argResults[_distribution] != null) {
      return Distribution.forName(argResults[_distribution]);
    }
    final ask = Select(
        prompt: localizations.chooseServerDistro,
        options: Distribution.all
            .map((e) => recommend(e.displayName, e.recommended))
            .toList());

    final distributionIndex = ask.interact();
    return Distribution.all[distributionIndex];
  }
}
