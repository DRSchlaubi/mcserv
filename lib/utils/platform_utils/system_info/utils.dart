part of system_info;

String? _exec(String executable, List<String> arguments,
    {bool runInShell = false}) {
  try {
    final result =
    Process.runSync(executable, arguments, runInShell: runInShell);
    if (result.exitCode == 0) {
      return result.stdout.toString();
    }
  } catch (e) {
    //
  }

  return null;
}
