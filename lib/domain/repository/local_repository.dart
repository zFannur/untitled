import '../entity/operation.dart';

abstract class LocalRepository {

  Future<void> init();
  void addOperation(Operation operation);
  Future<void> addOperationList(List<Operation> operation);
  void editOperation(int index, Operation operation);
  int getNewId();
  void deleteOperation(int index);
  Future<void> deleteAllOperation();
  List<Operation> getOperation();

  List<Operation> getCache();
  void addCache(Operation operation);
  void deleteCache();
}