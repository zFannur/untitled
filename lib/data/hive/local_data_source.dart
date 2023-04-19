import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/operation_model.dart';

class LocalDataSourceHive {
  final operationKey = 'operation';
  final operationSendKey = 'operationSendKey';
  final operationEditKey = 'operationEditKey';


  Future<void> init() async {
    final applicationDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(applicationDocumentDir.path)
      ..registerAdapter(OperationModelHiveAdapter());

    await Hive.openBox<OperationModelHive>(operationKey);
    await Hive.openBox<OperationModelHive>(operationSendKey);
  }

  void addOperationHive(OperationModelHive operationModelHive, String key) {
    Hive.box<OperationModelHive>(key).add(operationModelHive);
  }

  void addListOperationHive(List<OperationModelHive> operationModelHive) {
    Hive.box<OperationModelHive>(operationKey).addAll(operationModelHive);
  }

  void editOperationHive(int index, OperationModelHive operationModelHive) {
    Hive.box<OperationModelHive>(operationKey).putAt(index, operationModelHive);
  }

  int getId() {
    int oldValue = 0;
    final result = Hive.box<OperationModelHive>(operationKey).values.toList();

    for (int i = 0; i < result.length; i++) {
      if (oldValue < result[i].id) {
        oldValue = result[i].id;
      }
    }
    return oldValue += 1;
  }

  void deleteOperationHive(int index, String key) {
    Hive.box<OperationModelHive>(key).deleteAt(index);
  }

  void deleteAllHive() {
    Hive.box<OperationModelHive>(operationKey).clear();
  }

  List<OperationModelHive> getOperationLocal(String key) {
    final result = Hive.box<OperationModelHive>(key).values.toList();
    return result;
  }
}
