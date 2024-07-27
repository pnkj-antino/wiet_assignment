import 'package:get_it/get_it.dart';
import 'package:wiet_assignment/service/api_service.dart';

final locator = GetIt.I;
void setupLocator() {
  locator.registerSingleton<ApiService>(ApiService());
}
