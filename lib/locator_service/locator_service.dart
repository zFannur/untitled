import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled/domain/use_case/api_use_case.dart';
import 'package:untitled/domain/use_case/hive_use_case.dart';
import 'package:untitled/presentation/bloc/operation_bloc/operation_bloc.dart';
import 'package:untitled/presentation/bloc/operation_change_bloc/operation_change_bloc.dart';
import '../bloc_observable.dart';
import '../data/api/api_client.dart';
import '../data/hive/local_data_source.dart';
import '../domain/repository/api_repository.dart';
import '../domain/repository/hive_repository.dart';
import '../presentation/bloc/statistic_bloc/statistic_bloc.dart';

GetIt getIt = GetIt.instance;

Future<void> init() async {

  Bloc.observer = CharacterBlocObservable();

  //data
  getIt.registerFactory<ApiClient>(() => ApiClientImpl());
  getIt.registerFactory<LocalDataSourceHive>(() => LocalDataSourceHiveImpl());

  //domain
  getIt.registerFactory<ApiUseCase>(() => ApiUseCaseImpl(apiClient: getIt<ApiClient>()));
  HiveUseCase hiveUseCase = HiveUseCaseImpl(localDataSourceHive: getIt<LocalDataSourceHive>());
  await hiveUseCase.initHive();
  getIt.registerFactory<HiveUseCase>(() => hiveUseCase);


  //presentation
  getIt.registerSingleton(OperationBloc(apiService: getIt<ApiUseCase>(), hiveService: getIt<HiveUseCase>()));
  getIt.registerSingleton(OperationChangeBloc());
  getIt.registerSingleton(StatisticBloc());
}