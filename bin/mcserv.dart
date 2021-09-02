import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/locale.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/intl/localizations.dart';
import 'package:mcserv/utils/fs_util.dart';
import 'package:mcserv/utils/localizations_util.dart';
import 'package:mcserv/utils/utils.dart';
import 'package:path/path.dart' as path;

import 'commands/command.dart';

Future<ArgResults> _parseArguments(
    ArgParser parser, List<String> arguments) async {
  final commandNames = allCommands.map((e) => e.name);
  commandNames.forEach(parser.addCommand);

  parser.addFlag('verbose',
      abbr: 'v', help: localizations.verboseLoggingHelp, negatable: false);
  parser.addFlag('version');
  parser.addFlag('help',
      abbr: 'h', help: localizations.helpFlagHelp, negatable: false);
  parser.addOption('log-level',
      help: localizations.logLevelHelp,
      defaultsTo: 'INFO',
      allowed: Level.LEVELS.map((e) => e.name));

  try {
    final args = parser.parse(arguments);
    return args;
  } on FormatException catch (e) {
    _help(parser, e: e);
  }
}

Never _help(ArgParser parser, {FormatException? e}) {
  if (e != null) {
    print('E: ${e.message}');
  }
  print(parser.usage);
  exit(1);
}

Future<void> _initalFlags(ArgParser parser, ArgResults args) async {
  if (args['help']) {
    _help(parser);
  }
  if (args['version']) {
    await _version();
  }
}

void _initLogger(ArgResults args) {
  final level = args['verbose']
      ? Level.FINE
      : Level.LEVELS.firstWhere((element) => element.name == args['log-level']);

  Logger.root.level = level;
  Logger.root.onRecord.listen((record) =>
      print('${record.level.name}: ${record.time}: ${record.message}'));
}

Command _pickCommand(ArgResults arguments) {
  final name = arguments.command?.name;
  if (name != null) {
    return allCommands.firstWhere((element) => element.name == name);
  }

  final select = Select(
          prompt: localizations.pickCommand,
          options: allCommands.map((e) => e.prompt).toList())
      .interact();

  return allCommands[select];
}

Future<void> _initI18n() async {
  final systemLocale = await findSystemLocale();

  var name =
      systemLocale.length >= 4 ? systemLocale.substring(0, 5) : systemLocale;
  localizations = await Localizations.load(Locale.parse(name));
}

void main(List<String> arguments) async {
  await _initI18n();
  final parser = ArgParser();
  final args = await _parseArguments(parser, arguments);
  _initLogger(args);
  await _initalFlags(parser, args);

  final command = _pickCommand(args);

  await command.execute();
}

Future<void> _version() async {
  final mcServInstall = getInstallationDirectory();
  final versionFile = fs.file(path.joinAll([...mcServInstall, 'version.txt']));
  Logger('Main').fine('Reading version from ${versionFile.absolute.path}');
  final versionText = await versionFile.readAsString();

  print('McServ $versionText');

  exit(0);
}
