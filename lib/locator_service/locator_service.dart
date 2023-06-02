import 'package:get_it/get_it.dart';
import 'package:untitled/domain/use_case/api_use_case.dart';
import 'package:untitled/domain/use_case/hive_use_case.dart';
import 'package:untitled/presentation/bloc/operation_bloc/operation_bloc.dart';
import 'package:untitled/presentation/bloc/operation_change_bloc/operation_change_bloc.dart';
import '../data/api/api_client.dart';
import '../data/hive/local_data_source.dart';
import '../domain/repository/api_repository.dart';
import '../domain/repository/hive_repository.dart';

GetIt getIt = GetIt.instance;

Future<void> init() async {

  //data
  getIt.registerFactory<ApiClient>(() => ApiClientImpl());
  getIt.registerFactory<LocalDataSourceHive>(() => LocalDataSourceHiveImpl());

  //domain
  getIt.registerFactory<ApiUseCase>(() => ApiUseCaseImpl(apiClient: getIt<ApiClient>()));
  getIt.registerFactory<HiveUseCase>(() => HiveUseCaseImpl(localDataSourceHive: getIt<LocalDataSourceHive>()));

  //presentation
  getIt.registerSingleton(OperationBloc(apiService: getIt<ApiUseCase>(), hiveService: getIt<HiveUseCase>()));
  getIt.registerSingleton(OperationChangeBloc());
}