import 'package:file/file.dart';
import 'package:interact/interact.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/distributions/distribution.dart';
import 'package:mcserv/distributions/metadata/distribution_api.dart';
import 'package:mcserv/jdk/chooser.dart';
import 'package:mcserv/mc_installer/mc_installer_helper.dart';
import 'package:mcserv/script/script_generator.dart';
import 'package:mcserv/settings/settings.dart';
import 'package:mcserv/settings/settings_helper.dart';
import 'package:mcserv/utils/constants.dart';
import 'package:mcserv/utils/recommendation_util.dart';
import 'package:mcserv/utils/utils.dart';

const String _mcEula = 'https://account.mojang.com/documents/minecraft_eula';

var _log = Logger('NewCommand');

class NewCommand extends Command {
  final _metadata = DistributionMetaDataApi(makeDio(_log));

  @override
  String get prompt => localizations.newCommand;

  @override
  String get name => 'new';

  @override
  Future<void> execute() async {
    final directory = await _askDirectory();
    final distribution = _askDistribution();
    final acceptEula = distribution.requiresEula
        ? confirm(localizations.acceptEula(_mcEula), defaultValue: true)
        : false;

    final version = await distribution.askForVersion();

    final meta = distribution.hasMetadata
        ? (await _metadata.getDistributionMetaData(distribution.name))
        : null;
    final versionMeta =
        meta?.versions.firstWhere((element) => element.version == version);
    final useRecommendedFlags = versionMeta?.recommendedFlagKey != null
        ? confirm(localizations.useAikarFlags, defaultValue: true)
        : false;

    final jre = await choseJRE(
        from: versionMeta?.javaOptions.min, to: versionMeta?.javaOptions.max);

    final build = await distribution.installServer(version, directory);
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
  }

  Future<Directory> _askDirectory() async {
    final ask = Input(prompt: localizations.destinationDirectory);

    final path = ask.interact();
    final directory = fs.directory(path);
    if (!await directory.exists()) {
      if (!confirm(localizations.overwriteDestinationDirectory)) {
        return _askDirectory();
      }

      await directory.create();
    }

    if (!(await directory.list().isEmpty)) {
      if (!confirm(localizations.createDestinationDirectory)) {
        return _askDirectory();
      }
    }

    return directory;
  }

  Distribution _askDistribution() {
    final ask = Select(
        prompt: localizations.chooseServerDistro,
        options: Distribution.all
            .map((e) => recommend(e.displayName, e.recommended))
            .toList());

    final distributionIndex = ask.interact();
    return Distribution.all[distributionIndex];
  }
}
