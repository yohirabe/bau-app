import 'package:bau_app/services/patient_api_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
}
