import 'dart:io';

import 'package:dio/dio.dart';

class ElectionDataSource {
  var dioClient = Dio();
  String url =
      "https://mainnet-api.maticvigil.com/v1.0/contract/0xd848bed313d2c85db9525f220814595cc48aaf52";
  var httpClient = HttpClient();
  Future<String> getAdmin() async {
    var response = await dioClient.get(
        "https://mainnet-api.maticvigil.com/v1.0/contract/0xd848bed313d2c85db9525f220814595cc48aaf52/admin");
    print(response.data);
    return response.data["data"][0]["address"];
  }
}
