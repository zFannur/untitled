import 'package:untitled/data/entity/operation_api.dart';
import '../../domain/entity/operation.dart';
import 'operation_hive.dart';

//переделать под конвертация массива с типом Т, и конвертация объекта с типом Т
//оставить только 2 функции с именем convertOperation

class ConvertOperation {

  static List<Operation> operationApiToOperationList(List<OperationApi> operationsApi) {
    List<Operation> result = [];

    for (int i = 0; i < operationsApi.length; i++) {
      final operation = Operation(
        id: operationsApi[i].id,
        action: operationsApi[i].action,
        date: operationsApi[i].date,
        type: operationsApi[i].type,
        form: operationsApi[i].form,
        sum: operationsApi[i].sum,
        note: operationsApi[i].note,
      );
      result.add(operation);
    }
    return result;
  }

  static OperationApi operationToOperationApi(Operation operation) {
    final operationApi = OperationApi(
      id: operation.id,
      action: operation.action,
      date: operation.date,
      type: operation.type,
      form: operation.form,
      sum: operation.sum,
      note: operation.note,
    );
    return operationApi;
  }


  static OperationHive operationToOperationModel(Operation operation) {
    final operationModel = OperationHive(
      id: operation.id,
      action: operation.action,
      date: operation.date,
      type: operation.type,
      form: operation.form,
      sum: operation.sum,
      note: operation.note,
    );
    return operationModel;
  }

  static List<OperationHive> operationToOperationModelList(List<Operation> operations) {
    List<OperationHive> result = [];

    for (int i = 0; i < operations.length; i++) {
      final operation = OperationHive(
        id: operations[i].id,
        action: operations[i].action,
        date: operations[i].date,
        type: operations[i].type,
        form: operations[i].form,
        sum: operations[i].sum,
        note: operations[i].note,
      );
      result.add(operation);
    }
    return result;
  }

  static List<Operation> operationModelToOperation(
      List<OperationHive> operationModelHive) {
    List<Operation> result = [];

    for (int i = 0; i < operationModelHive.length; i++) {
      final operation = Operation(
        id: operationModelHive[i].id,
        action: operationModelHive[i].action,
        date: operationModelHive[i].date,
        type: operationModelHive[i].type,
        form: operationModelHive[i].form,
        sum: operationModelHive[i].sum,
        note: operationModelHive[i].note,
      );
      result.add(operation);
    }

    return result;
  }
}
