import 'package:interact/interact.dart';

bool confirm(String prompt, {defaultValue = false, waitForNewLine = false}) {
  var confirm = Confirm(
          prompt: prompt,
          defaultValue: defaultValue,
          waitForNewLine: waitForNewLine);

  return confirm.interact();
}
