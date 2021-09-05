import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart' as command_runner;
import 'package:meta/meta.dart';

abstract class Command extends command_runner.Command<void> {
  Command() {
    addOptions();
  }

  String get prompt;

  @override
  String get name;

  @override
  ArgResults get argResults => super.argResults!;

  @override
  String get description => 'throw UnimplementedError();';

  @override
  FutureOr<void> run() => execute();

  Future<void> execute() async {}

  @protected
  void addOptions() {}
}
