import 'package:interact/interact.dart';

const yesFlag = 'yes';

bool confirm(String prompt,
    {defaultValue = false, waitForNewLine = false, bool? predefined}) {
  if (predefined != null) {
    return predefined;
  }

  final confirm = Confirm(
      prompt: prompt,
      defaultValue: defaultValue,
      waitForNewLine: waitForNewLine);

  return confirm.interact();
}
