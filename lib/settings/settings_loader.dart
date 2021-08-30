import 'dart:convert';

import 'package:mcserv/utils/utils.dart';

import 'settings.dart';

Future<Settings> loadSettings() async {
  var settingsFile = await getServersFile();
  var content = await settingsFile.readAsString();
  if (content.isEmpty) {
    return Settings([]);
  } else {
    var json = jsonDecode(content);

    return Settings.fromJson(json);
  }
}

Future<void> saveSettings(Settings settings) async {
  var settingsFile = await getServersFile();

  var json = jsonEncode(settings.toJson());

  await settingsFile.writeAsString(json);
}
