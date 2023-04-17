import 'package:untitled/domain/entity/operation.dart';

import '../../data/hive/local_data_source.dart';

class HiveService {
  LocalDataSourceHive localDataSourceHive = LocalDataSourceHive();

  Future<void> initHive() async {
    await localDataSourceHive.init();
  }

  void addList(List<Operation> operation) {
    localDataSourceHive.addListOperationHive(operation.map((e) => e.operationToOperationModel(e)).toList());
  }

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

    localDataSourceHive
        .addOperationHive(operation.operationToOperationModel(operation));
  }

  List<Operation> getOperation() {
    List<Operation> operations = [];
    operations = localDataSourceHive.getOperationLocal();
    print(operations.isEmpty ? 'empty' : operations.last.id);
    return operations;
  }

  void editOperation({
    required int id,
    required int index,
    required String date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) {
    final operation = Operation(
      action: '',
      date: date,
      type: type,
      form: form,
      sum: sum,
      note: note,
      id: id,
    );

    localDataSourceHive.editOperationHive(index, operation.operationToOperationModel(operation));
  }

  int getNewId() {
    return localDataSourceHive.getId();
  }

  void deleteAll() {
    localDataSourceHive.deleteAllHive();
  }

  void deleteOperation(int index) {
    localDataSourceHive.deleteOperationHive(index);
  }
}
