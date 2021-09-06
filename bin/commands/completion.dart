import 'dart:io';

import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;
import 'package:logging/logging.dart';
import 'package:mcserv/utils/localizations_util.dart';

import 'abstract/non_promptable_command.dart';
import 'abstract/yes_flag_mixin.dart';

final _log = Logger('CompletionCommand');

class CompletionCommand extends NonPromptableCommand with YesFlag {
  @override
  String get name => 'completion';

  @override
  ArgParser get argParser => withYesFlag(ArgParser());

  @override
  Future<void> run() async {
    if (Platform.isWindows) {
      if (!globalConfirm(localizations.shellCompletionsOnWindows,
          defaultValue: false)) {
        return;
      }
    } else {
      final shellPath = Platform.environment['SHELL'] ?? '';
      _log.fine('Shell path is: $shellPath');
      if (!shellPath.endsWith('zsh') && !shellPath.endsWith('bash')) {
        if (!globalConfirm(localizations.shellNotSupported(shellPath))) {
          return;
        }
      }
    }

    print(completion.generateCompletionScript(['mcserv']));
  }
}
