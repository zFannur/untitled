import '../entity/operation.dart';

abstract class LocalDataSourceHive {
  String get operationKey;
  String get operationSendKey;

  Future<void> init();
  void addOperationHive(Operation operation, String key);
  Future<void> addListOperationHive(List<Operation> operation);
  void editOperationHive(int index, Operation operation);
  int getId();
  void deleteOperationHive(int index, String key);
  Future<void> deleteAllHive();
  List<Operation> getOperationLocal(String key);
}