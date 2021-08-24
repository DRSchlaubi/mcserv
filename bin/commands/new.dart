import 'package:file/file.dart';
import 'package:interact/interact.dart';

import '../distributions/distribution.dart';
import '../jdk/chooser.dart';
import '../script/script_generator.dart';
import '../utils/aikar_flags.dart' as aikar;
import '../utils/confirm.dart';
import '../utils/fs_util.dart';
import 'command.dart';

const String _mcEula = 'https://account.mojang.com/documents/minecraft_eula';

class NewCommand extends Command {
  @override
  String get prompt => 'Create a new server';

  @override
  String get name => 'new';

  @override
  Future<void> execute() async {
    final directory = await _askDirectory();
    final distribution = _askDistribution();
    final acceptEula = distribution.requiresEula
        ? confirm('Do you accept the MC Eula? ($_mcEula)', defaultValue: true)
        : false;

    final aikarFlags =
        confirm("Do you want to use Aikar's JVM flags?", defaultValue: true);

    final version = await _askVersion(distribution);

    final jre = await choseJRE();

    print('Downloading Distribution');
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
    final ask = Input(prompt: 'Destination directory');

    final path = ask.interact();
    final directory = fs.directory(path);
    if (!await directory.exists()) {
      if (!confirm(
          'Specified directory does not exist, do you want to create it?')) {
        return _askDirectory();
      }

      await directory.create();
    }

    if (!(await directory.list().isEmpty)) {
      if (!confirm(
          'The specified directory is not empty, do you want to proceed?')) {
        return _askDirectory();
      }
    }

    return directory;
  }

  Distribution _askDistribution() {
    final ask = Select(
        prompt: 'Chose Server Distribution',
        options: Distribution.all.map((e) => e.displayName).toList());

    final distributionIndex = ask.interact();
    return Distribution.all[distributionIndex];
  }

  Future<String> _askVersion(Distribution distribution) async {
    final versionsGroups = await distribution.retrieveVersionGroups();
    final ask = Select(prompt: 'Choose Server Version', options: versionsGroups);
    final versionGroupIndex = ask.interact();
    final selectedVersionGroup = versionsGroups[versionGroupIndex];
    final versions =
        (await distribution.retrieveVersions(selectedVersionGroup)).versions;
    if (versions.length > 1) {
      final versionAsk = Select(prompt: 'Choose Subversion', options: versions);
      final versionIndex = versionAsk.interact();
      return versions[versionIndex];
    }
    return versions.first;
  }
}
