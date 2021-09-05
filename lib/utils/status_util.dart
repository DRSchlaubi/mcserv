import 'package:interact/interact.dart';

typedef ExpensiveTask = Future<void> Function(Status status);

class Status {
  final String? donePrompt;
  String? prompt;

  final SpinnerState _spinner;
  var _done = false;

  Status(this.donePrompt, this.prompt)
      : _spinner = Spinner(
                icon: Theme.defaultTheme.successPrefix,
                rightPrompt: (done) => done ? donePrompt ?? '' : prompt ?? '')
            .interact();

  void done() {
    _done = true;
    _spinner.done();
  }
}

Future<void> doInProgress(ExpensiveTask task,
    {String? donePrompt, String? initialPrompt}) async {
  final status = Status(donePrompt, initialPrompt);
  await task(status);
  if (!status._done) {
    status.done();
  }
}
