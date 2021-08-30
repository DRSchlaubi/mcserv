import 'package:mcserv/commands/command.dart';

import 'delete.dart';
import 'detect.dart';
import 'new.dart';
import 'update.dart';

final List<Command> ALL_COMMANDS = [
  NewCommand(),
  DetectCommand(),
  UpdateCommand(),
  DeleteCommand(),
];
