import 'package:mcserv/distributions/pl3x/pl3x_distribution.dart';

class PurPurDistribution extends Pl3xDistribution {
  @override
  String get displayName => 'Purpur';

  @override
  bool get hasMetadata => true;

  @override
  String get metadataKey => "paper";

  @override
  String get name => 'purpur';

  @override
  String get project => name;
}
