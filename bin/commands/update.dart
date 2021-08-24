import '../mcserve.dart';
import 'command.dart';

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get prompt => localizations.updateCommand;

}
