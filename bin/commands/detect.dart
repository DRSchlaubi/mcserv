import 'package:mcserve/commands/command.dart';
import 'package:mcserve/utils/utils.dart';

class DetectCommand extends Command {
  @override
  String get name => 'detect';

  @override
  String get prompt => localizations.detectCommand;
}
