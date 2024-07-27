import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:wiet_assignment/pages/home/models/cat_model.dart';
import 'package:wiet_assignment/routes/api_routes.dart';
import 'package:wiet_assignment/service/api_service.dart';
import 'package:wiet_assignment/utils/di.dart';

class HomeRepository {
  final ApiService _apiService = locator<ApiService>();

  Future<CatModel?> getData() async {
    try {
      final Response response = await _apiService.dio.get(
        ApiRoutes.getCats,
      );
      if (response.statusCode == 200) {
        return CatModel.fromJson(response.data);
      }
      return null;
    } on Exception catch (e) {
      log(e.toString());
      return null;
    }
  }
}
