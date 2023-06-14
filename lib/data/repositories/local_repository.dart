import 'package:hive/hive.dart';
import 'package:untitled/domain/entity/operation.dart';
import 'package:untitled/domain/repository/local_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/converter.dart';
import '../models/operation_hive.dart';

class LocalRepositoryImpl extends LocalRepository {
  LocalRepositoryImpl();

  final operationKey = 'operationKey';
  final cacheKey = 'cacheKey';

  @override
  Future<void> init() async {
    final applicationDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(applicationDocumentDir.path)
      ..registerAdapter(OperationHiveAdapter());

    await Hive.openBox<OperationHive>(operationKey);
    await Hive.openBox<OperationHive>(cacheKey);
  }

  @override
  void addCache(Operation operation) {
    Hive.box<OperationHive>(cacheKey).add(ConvertOperation.operationToOperationModel(operation));
  }

  @override
  List<Operation> getCache() {
    return ConvertOperation.operationModelToOperation(Hive.box<OperationHive>(cacheKey).values.toList());
  }

  @override
  void deleteCache() {
    Hive.box<OperationHive>(cacheKey).deleteAt(0);
  }

  @override
  void addOperation(Operation operation) {
    Hive.box<OperationHive>(operationKey).add(ConvertOperation.operationToOperationModel(operation));
  }

  @override
  Future<void> addOperationList(List<Operation> operation) async {
    await Hive.box<OperationHive>(operationKey).addAll(ConvertOperation.operationToOperationModelList(operation));
  }

  @override
  Future<void> deleteAllOperation() async {
    await Hive.box<OperationHive>(operationKey).clear();
  }

  @override
  void deleteOperation(int index) {
    Hive.box<OperationHive>(operationKey).deleteAt(index);
  }

  @override
  void editOperation(int index, Operation operation) {
    Hive.box<OperationHive>(operationKey).putAt(index, ConvertOperation.operationToOperationModel(operation));
  }

  @override
  int getNewId() {
    int oldValue = 0;
    final result = Hive.box<OperationHive>(operationKey).values.toList();

    for (int i = 0; i < result.length; i++) {
      if (oldValue < result[i].id) {
        oldValue = result[i].id;
      }
    }
    return oldValue += 1;
  }

  @override
  List<Operation> getOperation() {
    return ConvertOperation.operationModelToOperation(Hive.box<OperationHive>(operationKey).values.toList());
  }

}