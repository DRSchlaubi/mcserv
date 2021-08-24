import 'dart:io';

extension PorcessUtil on ProcessResult {
  String get safeOutput =>
      ((this.stdout as String).isEmpty ? this.stderr : this.stdout) as String;
}
