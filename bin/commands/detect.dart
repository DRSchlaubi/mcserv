import '../mcserve.dart';
import 'command.dart';

class DetectCommand extends Command {
  @override
  String get name => 'detect';

  @override
  String get prompt => localizations.detectCommand;

}
