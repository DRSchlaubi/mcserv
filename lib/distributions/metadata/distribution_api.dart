import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'metadata.dart';

part 'distribution_api.g.dart';

@RestApi(
    baseUrl: 'https://github.com/DRSchlaubi/mcserv/raw/main/distributions/')
abstract class DistributionMetaDataApi {
  factory DistributionMetaDataApi(Dio dio, {String baseUrl}) =
      _DistributionMetaDataApi;

  @GET('/{type}.json')
  Future<DistributionMetaData> getDistributionMetaData(
      @Path('type') String type);
}
