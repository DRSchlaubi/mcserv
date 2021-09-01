import 'package:mcserv/commands/command.dart';
import 'package:mcserv/utils/utils.dart';

class DetectCommand extends Command {
  @override
  String get name => 'detect';

  @override
  String get prompt => localizations.detectCommand;

  @override
  Future<void> execute() async {
    print('This feature is currently in development');
  }
}
