import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled/data/repositories/local_repository_impl.dart';
import 'package:untitled/data/repositories/remote_repository_impl.dart';
import 'package:untitled/data/repositories/remote_repository_impl_dio.dart';
import 'package:untitled/domain/repository/local_repository.dart';
import 'package:untitled/domain/repository/remote_repository.dart';
import 'package:untitled/domain/use_case/operation_use_case.dart';
import 'package:untitled/domain/use_case/operation_use_case_impl.dart';
import 'package:untitled/domain/use_case/plan_use_case_impl.dart';
import 'package:untitled/presentation/bloc/operation_bloc/operation_bloc.dart';
import 'package:untitled/presentation/bloc/operation_change_bloc/operation_change_bloc.dart';
import 'package:untitled/presentation/bloc/plan_bloc/plan_bloc.dart';
import '../bloc_observable.dart';
import '../domain/use_case/plan_use_case.dart';
import '../presentation/bloc/statistic_bloc/statistic_bloc.dart';

GetIt getIt = GetIt.instance;

Future<void> init() async {
  Bloc.observer = CharacterBlocObservable();

  //data
  //getIt.registerFactory<RemoteRepository>(() => RemoteRepositoryImplNew(Dio()));

  getIt.registerFactory<RemoteRepository>(() => RemoteRepositoryImpl());
  getIt.registerFactory<LocalRepository>(() => LocalRepositoryImpl());

  LocalRepository localRepository = getIt<LocalRepository>();
  await localRepository.init();

  //domain
  getIt.registerFactory<OperationUseCase>(() => OperationUseCaseImpl(
        localRepository: getIt<LocalRepository>(),
        remoteRepository: getIt<RemoteRepository>(),
      ));
  getIt.registerFactory<PlanUseCase>(() => PlanUseCaseImpl(
    localRepository: getIt<LocalRepository>(),
    remoteRepository: getIt<RemoteRepository>(),
  ));

  //presentation
  getIt.registerSingleton(OperationBloc(getIt<OperationUseCase>()));
  getIt.registerSingleton(OperationChangeBloc());
  getIt.registerSingleton(StatisticBloc());
  getIt.registerSingleton(PlanBloc(getIt<PlanUseCase>()));
}
