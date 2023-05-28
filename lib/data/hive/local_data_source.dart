import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:untitled/domain/entity/operation.dart';
import 'package:untitled/domain/service/hive_service.dart';
import '../models/converter.dart';
import '../models/operation_hive.dart';

class LocalDataSourceHiveImpl implements LocalDataSourceHive {
  @override
  get operationKey => 'operation';
  @override
  get operationSendKey => 'operationSendKey';

  @override
  Future<void> init() async {
    final applicationDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive
      ..init(applicationDocumentDir.path)
      ..registerAdapter(OperationModelHiveAdapter());

    await Hive.openBox<OperationHive>(operationKey);
    await Hive.openBox<OperationHive>(operationSendKey);
  }

  @override
  void addOperationHive(Operation operation, String key) {
    Hive.box<OperationHive>(key).add(ConvertOperation.operationToOperationModel(operation));
  }

  @override
  void addListOperationHive(List<Operation> operation) {
    Hive.box<OperationHive>(operationKey).addAll(ConvertOperation.operationToOperationModelList(operation));
  }

  @override
  void editOperationHive(int index, Operation operation) {
    Hive.box<OperationHive>(operationKey).putAt(index, ConvertOperation.operationToOperationModel(operation));
  }

  @override
  int getId() {
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
  void deleteOperationHive(int index, String key) {
    Hive.box<OperationHive>(key).deleteAt(index);
  }

  @override
  void deleteAllHive() {
    Hive.box<OperationHive>(operationKey).clear();
  }

  @override
  List<Operation> getOperationLocal(String key) {
    final result = ConvertOperation.operationModelToOperation(Hive.box<OperationHive>(key).values.toList());
    return result;
  }
}
