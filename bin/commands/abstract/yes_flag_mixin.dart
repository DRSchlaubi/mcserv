import 'package:args/args.dart';
import 'package:mcserv/commands/command.dart';
import 'package:mcserv/utils/confirm.dart' as confirm_lib;

mixin YesFlag on Command {
  bool get hasYesFlag => argResults[confirm_lib.yesFlag];

  ArgParser withYesFlag(ArgParser parser) => parser
    ..addFlag(confirm_lib.yesFlag,
        abbr: 'y', help: 'Answers all yes/no prompts with yes');

  bool globalConfirm(String prompt,
          {defaultValue = false, waitForNewLine = false}) =>
      confirm_lib.confirm(prompt,
          defaultValue: defaultValue,
          waitForNewLine: waitForNewLine,
          predefined: hasYesFlag);
}
