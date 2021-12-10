import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:completion/completion.dart' as completion;
import 'package:interact/interact.dart';
import 'package:intl/intl_standalone.dart';
import 'package:intl/locale.dart';
import 'package:logging/logging.dart';
import 'package:mcserv/intl/localizations.dart';
import 'package:mcserv/utils/utils.dart';
import 'package:path/path.dart' as path;

import 'commands/command.dart';

late StreamSubscription _sigIntListener;

Future<ArgResults> _parseArguments(
    ArgParser parser, List<String> arguments) async {
  for (var command in allCommands) {
    parser.addCommand(command.name, command.argParser);
  }
  parser.addCommand('help');

  parser.addFlag('verbose',
      abbr: 'v', help: localizations.verboseLoggingHelp, negatable: false);
  parser.addFlag('version');
  parser.addFlag('ascii', negatable: true, defaultsTo: Platform.isWindows);
  parser.addFlag('help',
      abbr: 'h', help: localizations.helpFlagHelp, negatable: false);
  parser.addOption('log-level',
      help: localizations.logLevelHelp,
      defaultsTo: 'INFO',
      allowed: Level.LEVELS.map((e) => e.name));

  try {
    final args = completion.tryArgsCompletion(arguments, parser);
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

Future<void> _initialFlags(ArgParser parser, ArgResults args) async {
  if (args['version']) {
    await _version();
  }
  if (args['ascii']) {
    Theme.defaultTheme = Theme.basicTheme;
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

ArgResults _pickCommand(
    Iterable<String> args, ArgParser parser, ArgResults arguments) {
  final command = arguments.command;
  if (command != null) {
    return arguments;
  }

  final select = Select(
          prompt: localizations.pickCommand,
          options: allCommands
              .where((e) => e.promptable)
              .map((e) => e.prompt)
              .toList())
      .interact();

  return parser.parse([...args, allCommands[select].name]);
}

Future<void> _initI18n() async {
  final systemLocale = await findSystemLocale();

  final name =
      systemLocale.length >= 4 ? systemLocale.substring(0, 5) : systemLocale;
  var locale = Locale.parse("en_US");
  try {
    locale = Locale.parse(name);
  } on FormatException catch (e) {
    Logger('LocaleLoader').warning('Could not load locale', e);
  }
  localizations = await Localizations.load(locale);
}

void main(List<String> arguments) async {
  _catchSigint();
  await _initI18n();
  final parser = ArgParser();
  final args = await _parseArguments(parser, arguments);
  _initLogger(args);
  await _initialFlags(parser, args);

  final runner = CommandRunner('mcserv', 'mcservdesc');
  allCommands.forEach(runner.addCommand);

  final commandArgs = _pickCommand(arguments, parser, args);

  await runner.runCommand(commandArgs);

  _close(!arguments.contains(completion.completionCommandName));
}

void _catchSigint() {
  // Reset interact cursor to avoid cursor being invisible after SIGINT
  var sigints = 0;
  _sigIntListener = ProcessSignal.sigint.watch().listen((event) {
    if (sigints++ >= 1) {
      exit(1);
    } else {
      _close(true);
    }
  });
}

void _close(bool resetInteract) {
  if(resetInteract) {
    reset();
  }
  _sigIntListener.cancel();
  closeDio();
}

Future<void> _version() async {
  final mcServInstall = getInstallationDirectory();
  final versionFile = findFile(path.joinAll([...mcServInstall, 'version.txt']));
  Logger('Main').fine('Reading version from ${versionFile.absolute.path}');
  final versionText = await versionFile.readAsString();

  print('McServ $versionText');

  exit(0);
}
