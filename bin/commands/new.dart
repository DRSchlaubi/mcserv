import 'package:file/file.dart';
import 'package:interact/interact.dart';

import '../distributions/distribution.dart';
import '../jdk/chooser.dart';
import '../mcserve.dart';
import '../script/script_generator.dart';
import '../utils/aikar_flags.dart' as aikar;
import '../utils/confirm.dart';
import '../utils/fs_util.dart';
import 'command.dart';

const String _mcEula = 'https://account.mojang.com/documents/minecraft_eula';

class NewCommand extends Command {
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

    final aikarFlags = confirm(localizations.useAikarFlags, defaultValue: true);

    final version = await _askVersion(distribution);

    final jre = await choseJRE();

    print(localizations.downloadingDistro);
    await distribution.downloadTo(version, directory.childFile('server.jar'));
    final scriptGen = ScriptGenerator.forPlatform();

    await scriptGen.writeStartScript(directory, 'server.jar', jre.path,
        [if (aikarFlags) ...aikar.aikarFlags]);

    if (acceptEula) {
      final eula = directory.childFile('eula.txt');
      await eula.writeAsString('eula=true');
    }
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
        options: Distribution.all.map((e) => e.displayName).toList());

    final distributionIndex = ask.interact();
    return Distribution.all[distributionIndex];
  }

  Future<String> _askVersion(Distribution distribution) async {
    final versionsGroups = await distribution.retrieveVersionGroups();
    final ask = Select(
        prompt: localizations.chooseServerVersion, options: versionsGroups);
    final versionGroupIndex = ask.interact();
    final selectedVersionGroup = versionsGroups[versionGroupIndex];
    final versions =
        (await distribution.retrieveVersions(selectedVersionGroup)).versions;
    if (versions.length > 1) {
      final versionAsk = Select(
          prompt: localizations.chooseServerSubVersion, options: versions);
      final versionIndex = versionAsk.interact();
      return versions[versionIndex];
    }
    return versions.first;
  }
}
