import 'package:file/file.dart';
import 'package:interact/interact.dart';
import 'package:mcserve/commands/command.dart';
import 'package:mcserve/distributions/distribution.dart';
import 'package:mcserve/jdk/chooser.dart';
import 'package:mcserve/script/script_generator.dart';
import 'package:mcserve/mc_installer/mc_installer_helper.dart';
import 'package:mcserve/utils/utils.dart';
import 'package:mcserve/utils/aikar_flags.dart' as aikar;
import 'package:mcserve/settings/settings.dart';
import 'package:mcserve/settings/settings_helper.dart';

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

    final version = await distribution.askForVersion();

    final jre = await choseJRE();

    final build = await distribution.installServer(version, directory);
    final scriptGen = ScriptGenerator.forPlatform();

    await scriptGen.writeStartScript(directory, 'server.jar', jre.path,
        [if (aikarFlags) ...aikar.aikarFlags]);

    if (acceptEula) {
      final eula = directory.childFile('eula.txt');
      await eula.writeAsString('eula=true');
    }

    await addServer(Installation(
        distribution.name, version, directory.absolute.path, build));
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
}
