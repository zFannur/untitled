import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/operation_model.dart';

class LocalDataSourceHive {
  final operationKey = 'operation';

  Future<void> init() async {
    final applicationDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(applicationDocumentDir.path)
      ..registerAdapter(OperationModelHiveAdapter());

    await Hive.openBox<OperationModelHive>(operationKey);
  }

  void addOperationHive(OperationModelHive operationModelHive) {
    Hive.box<OperationModelHive>(operationKey).add(operationModelHive);
  }

  void changeOperationHive(int index, OperationModelHive operationModelHive) {
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

  void deleteOperationHive(int index) {
    Hive.box<OperationModelHive>(operationKey).deleteAt(index);

  }

  List<OperationModelHive> getOperationLocal() {
    final result = Hive.box<OperationModelHive>(operationKey).values.toList();
    return result;
  }

}
