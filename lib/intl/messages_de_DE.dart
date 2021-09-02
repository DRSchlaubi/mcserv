// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de_DE';

  static m0(eula) => "Akzeptierst du die MC Eula? (${eula})";

  static m1(languageVersion, update, path) =>
      "Java ${languageVersion} (${update}) in ${path}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "acceptEula": m0,
        "chooseServerDistro": MessageLookupByLibrary.simpleMessage(
            "Server Distribution auswählen"),
        "chooseServerSubVersion":
            MessageLookupByLibrary.simpleMessage("Unterversion auswählen"),
        "chooseServerVersion":
            MessageLookupByLibrary.simpleMessage("Server Version auswählen"),
        "createDestinationDirectory": MessageLookupByLibrary.simpleMessage(
            "Der angegebene Ordner enthält bereits Dateien, möchtest du trotzdem fortfahren?"),
        "deleteCommand":
            MessageLookupByLibrary.simpleMessage("Einen Server Löschen"),
        "destinationDirectory":
            MessageLookupByLibrary.simpleMessage("Zielverzeichniss"),
        "detectCommand": MessageLookupByLibrary.simpleMessage(
            "Einen existierenden Server hinzufügen"),
        "downloadDone": MessageLookupByLibrary.simpleMessage(
            "Download abgeschlossen, Änderungen werden mit dem Dateisystem synchronisiert!"),
        "downloadingDistro": MessageLookupByLibrary.simpleMessage(
            "Distribution wird heruntergeladen"),
        "helpFlagHelp": MessageLookupByLibrary.simpleMessage(
            "Gibt diese Hilfsnachricht aus"),
        "javaInstallation": m1,
        "logLevelHelp":
            MessageLookupByLibrary.simpleMessage("Setzt das Level des Loggers"),
        "newCommand":
            MessageLookupByLibrary.simpleMessage("Neuen Server erstellen"),
        "overwriteDestinationDirectory": MessageLookupByLibrary.simpleMessage(
            "Der angegebene Ordner existiert nicht, möchtest du ihn erstellen?"),
        "overwriteExistingJava": MessageLookupByLibrary.simpleMessage(
            "Das ausgewählte JDK ist bereits installiert, möchtest du es überschreiben?"),
        "pickCommand":
            MessageLookupByLibrary.simpleMessage("Was möchtest du tun?"),
        "pickJavaInstallation": MessageLookupByLibrary.simpleMessage(
            "Welche Java Installation möchtest du benutzen?"),
        "pickLanguageVersion": MessageLookupByLibrary.simpleMessage(
            "Welche Version möchtest du installieren?"),
        "updateCommand": MessageLookupByLibrary.simpleMessage(
            "Einen existierenden Sever aktualisieren"),
        "useAikarFlags": MessageLookupByLibrary.simpleMessage(
            "Möchtest du Aikar\'s JVM flags nutzen?"),
        "verboseLoggingHelp":
            MessageLookupByLibrary.simpleMessage("Enables verbose logging")
      };
}
