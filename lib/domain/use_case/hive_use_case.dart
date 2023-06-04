import 'package:untitled/domain/entity/operation.dart';
import '../repository/hive_repository.dart';

abstract class HiveUseCase {
  Future<void> initHive();

  Future<void> addList(List<Operation> operation);

  void addOperation({
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });

  List<Operation> getOperation();

  void editOperation({
    required int index,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  });

  int getNewId();

  Future<void> deleteAll();

  void deleteOperationCache(int index);

  void deleteOperation(
    int index,
    int id,
  );

  List<Operation> getCache();
}


class HiveUseCaseImpl implements HiveUseCase{
  LocalDataSourceHive localDataSourceHive;
  HiveUseCaseImpl({required this.localDataSourceHive});

  @override
  Future<void> initHive() async {
    await localDataSourceHive.init();
  }

  @override
  Future<void> addList(List<Operation> operation) async {
    await localDataSourceHive.addListOperationHive(operation);
  }

  @override
  void addOperation({
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) {
    final operation = Operation(
      action: 'put',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );

    localDataSourceHive.addOperationHive(
        operation, localDataSourceHive.operationKey);
    localDataSourceHive.addOperationHive(
        operation, localDataSourceHive.operationSendKey);
  }

  @override
  List<Operation> getOperation() {
    List<Operation> operations = [];
    operations =
        localDataSourceHive.getOperationLocal(localDataSourceHive.operationKey);
    print(operations.isEmpty
        ? 'getHiveBox: empty'
        : 'last operation id: ${operations.last.id}');
    return operations;
  }

  @override
  List<Operation> getCache() {
    List<Operation> operations = [];
    operations = localDataSourceHive
        .getOperationLocal(localDataSourceHive.operationSendKey);
    return operations;
  }

  @override
  void editOperation({
    required int index,
    required int id,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) {
    final operation = Operation(
      action: 'edit',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );

    // List<Operation> operations = [];
    // int index = 0;
    // operations =
    //     localDataSourceHive.getOperationLocal(localDataSourceHive.operationKey);
    // for(int i = 0; i <= operations.length; i++) {
    //   if(operations[i].id == id) {
    //     index = i;
    //   }
    // }

    localDataSourceHive.editOperationHive(index, operation);
    localDataSourceHive.addOperationHive(
        operation, localDataSourceHive.operationSendKey);
  }

  @override
  int getNewId() {
    return localDataSourceHive.getId();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSourceHive.deleteAllHive();
  }

  @override
  void deleteOperationCache(int index) {
    localDataSourceHive.deleteOperationHive(
        index, localDataSourceHive.operationSendKey);
  }

  @override
  void deleteOperation(
    int index,
    int id,
  ) {
    final operation = Operation(
      action: 'del',
      date: '',
      type: '',
      form: '',
      sum: 0,
      note: '',
      id: id,
    );
    {
      localDataSourceHive.deleteOperationHive(
          index, localDataSourceHive.operationKey);

      localDataSourceHive.addOperationHive(
          operation, localDataSourceHive.operationSendKey);
    }
  }
}
