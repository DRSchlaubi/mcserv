import 'delete.dart';
import 'detect.dart';
import 'new.dart';
import 'update.dart';

abstract class Command {

  static List<Command> COMMANDS = [
    NewCommand(),
    DetectCommand(),
    UpdateCommand(),
    DeleteCommand()
  ];

  String get prompt;

  String get name;

  Future<void> execute() async {}
}
