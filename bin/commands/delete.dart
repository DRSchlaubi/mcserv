import '../mcserve.dart';
import 'command.dart';

class DeleteCommand extends Command {
  @override
  String get name => 'delete';

  @override
  String get prompt => localizations.deleteCommand;

}
