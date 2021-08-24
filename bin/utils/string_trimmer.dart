import 'dart:convert';

extension StringTrimmer on String {
  String trimIndent() {
    final lines = LineSplitter.split(this);
    String commonWhitespacePrefix(String a, String b) {
      var i = 0;
      for (; i < a.length && i < b.length; i++) {
        final ca = a.codeUnitAt(i);
        final cb = b.codeUnitAt(i);
        if (ca != cb) break;
        if (ca != 0x20 /* spc */ && ca != 0x09 /* tab */) break;
      }
      return a.substring(0, i);
    }
    final prefix = lines.reduce(commonWhitespacePrefix);
    final prefixLength = prefix.length;
    return lines.map((s) => s.substring(prefixLength)).join('\n');
  }
}
