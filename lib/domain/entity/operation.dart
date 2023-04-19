import '../../data/models/operation_model.dart';

class Operation {
  int id;
  String action;
  String date;
  String type;
  String form;
  int sum;
  String note;

  Operation({
    required this.id,
    required this.action,
    required this.date,
    required this.type,
    required this.form,
    required this.sum,
    required this.note,
  });

  Operation copyWith({
    int? id,
    String? action,
    String? date,
    String? type,
    String? form,
    int? sum,
    String? note,
  }) {
    return Operation(
      id: id ?? this.id,
      action: action ?? this.action,
      date: date ?? this.date,
      type: type ?? this.type,
      form: form ?? this.form,
      sum: sum ?? this.sum,
      note: note ?? this.note,
    );
  }

  static Operation fromJson(json) => Operation(
        id: json['id'] as int,
        action: json['action'] as String,
        date: json['date'] as String,
        type: json['type'] as String,
        form: json['form'] as String,
        sum: json['sum'] as int,
        note: json['note'] as String,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id.toString(),
      'date': date,
      'sum': sum.toString(),
      'action': action,
      'type': type,
      'form': form,
      'note': note,

    };
  }

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

class Argument {
  List<Operation> operations;
  int index;

  Argument({required this.operations, required this.index});
}

enum OperationModelFormType {
  type,
  form,
  note,
}
