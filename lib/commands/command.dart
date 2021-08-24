abstract class Command {

  String get prompt;

  String get name;

  Future<void> execute() async {}
}
