import 'paper_distribution.dart';

class WaterfallDistribution extends PaperDistribution {
  @override
  String get displayName => 'Waterfall';

  @override
  String get project => 'waterfall';

  @override
  bool get requiresEula => false;
}
