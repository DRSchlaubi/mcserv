import 'dart:io';

import 'package:args/args.dart';
import 'package:interact/interact.dart';
import 'package:logging/logging.dart';

import 'commands/command.dart';

ArgResults _parseArguments(List<String> arguments) {
  var commandNames = Command.COMMANDS.map((e) => e.name);
  var parser = ArgParser();
  commandNames.forEach((name) {
    parser.addCommand(name);
  });
  parser.addFlag('verbose',
      abbr: 'v', help: 'Enables verbose logging', negatable: false);
  parser.addFlag('help',
      abbr: 'h', help: 'Prints this help message', negatable: false);
  parser.addOption('log-level',
      help: 'Sets the log level',
      defaultsTo: 'INFO',
      allowed: Level.LEVELS.map((e) => e.name));

  try {
    var args = parser.parse(arguments);
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
  var level = args['verbose']
      ? Level.FINE
      : Level.LEVELS.firstWhere((element) => element.name == args['log-level']);

  Logger.root.level = level;
  Logger.root.onRecord.listen((record) =>
      print('${record.level.name}: ${record.time}: ${record.message}'));
}

Command _pickCommand(ArgResults arguments) {
  var name = arguments.command?.name;
  if (name != null) {
    return Command.COMMANDS.firstWhere((element) => element.name == name);
  }

  var select = Select(
          prompt: 'What do you want to do?',
          options: Command.COMMANDS.map((e) => e.prompt).toList())
      .interact();

  return Command.COMMANDS[select];
}

void main(List<String> arguments) async {
  var args = _parseArguments(arguments);
  _initLogger(args);

  var command = _pickCommand(args);

  await command.execute();
}
