import 'dart:convert';

extension StringTrimmer on String {
  String trimIndent() {
    var lines = LineSplitter.split(this);
    String commonWhitespacePrefix(String a, String b) {
      var i = 0;
      for (; i < a.length && i < b.length; i++) {
        var ca = a.codeUnitAt(i);
        var cb = b.codeUnitAt(i);
        if (ca != cb) break;
        if (ca != 0x20 /* spc */ && ca != 0x09 /* tab */) break;
      }
      return a.substring(0, i);
    }
    var prefix = lines.reduce(commonWhitespacePrefix);
    var prefixLength = prefix.length;
    return lines.map((s) => s.substring(prefixLength)).join('\n');
  }
}
