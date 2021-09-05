import 'package:args/args.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/utils/confirm.dart' as confirm_lib;
import 'package:mcserv/utils/localizations_util.dart';

mixin YesFlag on Command {
  bool? get yesFlagValue => argResults[confirm_lib.yesFlag];

  bool get hasYesFlag => argResults.wasParsed(confirm_lib.yesFlag);

  ArgParser withYesFlag(ArgParser parser) => parser
    ..addFlag(confirm_lib.yesFlag,
        abbr: 'y',
        defaultsTo: null,
        help: localizations.yesFlagDescription);

  bool globalConfirm(String prompt,
          {defaultValue = false, waitForNewLine = false}) =>
      confirm_lib.confirm(prompt,
          defaultValue: defaultValue,
          waitForNewLine: waitForNewLine,
          predefined: yesFlagValue);
}
