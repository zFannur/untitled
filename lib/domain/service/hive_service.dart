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
    int? id,
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
      id: id ?? getNewId(),
    );

    localDataSourceHive
        .addOperationHive(operation.operationToOperationModel(operation));
  }

  List<Operation> getOperation() {
    List<Operation> operations = [];
    operations = localDataSourceHive.getOperationLocal().cast<Operation>();
    print(operations.last.id);
    return operations;
  }

  void changeOperation({
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
      id: getNewId(),
    );

    //localDataSourceHive.changeOperationHive(operation.operationToOperationModel(operation));
  }

  int getNewId() {
    return localDataSourceHive.getId();
  }

  void deleteOperation(int index) {
    localDataSourceHive.deleteOperationHive(index);
  }
}
