import 'package:mcserv/commands/command.dart';

import 'completion.dart';
import 'delete.dart';
import 'detect.dart';
import 'new.dart';
import 'update.dart';

final List<Command> allCommands = [
  NewCommand(),
  DetectCommand(),
  UpdateCommand(),
  DeleteCommand(),
  CompletionCommand()
];
