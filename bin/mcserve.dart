import 'package:interact/interact.dart';
import 'package:logging/logging.dart';

import 'commands/delete.dart';
import 'commands/detect.dart';
import 'commands/new.dart';
import 'commands/update.dart';

var _commands = [
  NewCommand(),
  DetectCommand(),
  UpdateCommand(),
  DeleteCommand()
];

void main(List<String> arguments) async {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  if (arguments.isNotEmpty) {
    return _commands
        .firstWhere((element) => element.name == arguments.first)
        .execute();
  }

  var select = Select(
          prompt: 'What do you want to do?',
          options: _commands.map((e) => e.prompt).toList())
      .interact();

  var command = _commands[select];

  await command.execute();
}
