
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
