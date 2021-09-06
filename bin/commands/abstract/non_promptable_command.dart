import 'package:mcserv/commands/command.dart';

abstract class NonPromptableCommand extends Command {
  @override
  bool get promptable => false;

  @override
  String get prompt => throw UnsupportedError('This command is not promptable');
}
