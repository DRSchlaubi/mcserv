import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/locale.dart';
import 'package:logging/logging.dart';

import 'commands/command.dart';
import 'intl/localizations.dart';

late Localizations localizations;

ArgResults _parseArguments(List<String> arguments) {
  final commandNames = Command.COMMANDS.map((e) => e.name);
  final parser = ArgParser();
  commandNames.forEach((name) {
    parser.addCommand(name);
  });
  parser.addFlag('verbose',
      abbr: 'v', help: localizations.verboseLoggingHelp, negatable: false);
  parser.addFlag('help',
      abbr: 'h', help: localizations.helpFlagHelp, negatable: false);
  parser.addOption('log-level',
      help: localizations.logLevelHelp,
      defaultsTo: 'INFO',
      allowed: Level.LEVELS.map((e) => e.name));

  try {
    final args = parser.parse(arguments);
    if (args['help']) {
      _help(parser);
    }
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
    return Command.COMMANDS.firstWhere((element) => element.name == name);
  }

  final select = Select(
          prompt: localizations.pickCommand,
          options: Command.COMMANDS.map((e) => e.prompt).toList())
      .interact();

  return Command.COMMANDS[select];
}

Future<void> _initI18n() async {
  final systemLocale = await findSystemLocale();

  var name =
      systemLocale.length >= 4 ? systemLocale.substring(0, 5) : systemLocale;
  localizations =
      await Localizations.load(Locale.parse(name));
}

void main(List<String> arguments) async {
  await _initI18n();
  final args = _parseArguments(arguments);
  _initLogger(args);

  final command = _pickCommand(args);

  await command.execute();
}
