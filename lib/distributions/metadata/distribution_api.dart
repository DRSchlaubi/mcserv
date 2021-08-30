import 'dart:convert';

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
  Future<String?> _getDistributionMetaData(@Path('type') String type);

}

extension MetaDataTools on DistributionMetaDataApi {
  Future<DistributionMetaData?> getDistributionMetaData(String type) async {
    // GitHub responds plain/text here so DIO doesn't parse the json automatically
    final raw = await _getDistributionMetaData(type);
    if(raw == null) return null;
    final json = jsonDecode(raw);

    return DistributionMetaData.fromJson(json);
  }
}
