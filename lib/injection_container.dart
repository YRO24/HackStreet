import 'package:get_it/get_it.dart';
import 'data/sources/api_service.dart';
import 'data/repositories/credit_repository.dart';
import 'logic/credit_bloc/credit_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => CreditBloc(sl()));

  // Repository
  sl.registerLazySingleton(() => CreditRepository(sl()));

  // Data sources
  sl.registerLazySingleton(() => ApiService());
}
