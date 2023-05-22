import 'package:get_it/get_it.dart';
import '../presentation/add_operation/add_operation_model.dart';
//import '../presentation/operation/operation_model.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // sl.registerSingletonAsync<LocalDataSourceHive>(() async {
  //   final localDataSourceHive = LocalDataSourceHive();
  //   await localDataSourceHive.init();
  //   return localDataSourceHive;
  // });
  //
  // sl.registerSingleton(HiveService());
  sl.registerSingleton(AddOperationModel());
  //sl.registerSingleton(OperationModel());
}