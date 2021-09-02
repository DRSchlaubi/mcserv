import 'package:mcserv/utils/localizations_util.dart';

String recommend(String recommendation, bool recommend) => recommend
    ? recommendation + ' (${localizations.recommended})'
    : recommendation;
