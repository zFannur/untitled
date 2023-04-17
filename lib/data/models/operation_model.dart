import 'package:hive/hive.dart';
import 'package:untitled/domain/entity/operation.dart';

part 'operation_model.g.dart';

@HiveType(typeId: 0)
class OperationModelHive extends Operation {
  @override
  @HiveField(0)
  int id;
  @HiveField(1)
  String action;
  @HiveField(2)
  String date;
  @HiveField(3)
  String type;
  @HiveField(4)
  String form;
  @HiveField(5)
  int sum;
  @HiveField(6)
  String note;

  OperationModelHive(
      {required this.id,
      required this.action,
      required this.date,
      required this.type,
      required this.form,
      required this.sum,
      required this.note})
      : super(
          id: id,
          action: action,
          date: date,
          type: type,
          form: form,
          sum: sum,
          note: note,
        );

  OperationModelHive operationToOperationModel(Operation operation) {
    final operationModel = OperationModelHive(
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
}
