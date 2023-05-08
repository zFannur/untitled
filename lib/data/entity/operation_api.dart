class OperationApi {
  int id;
  String action;
  String date;
  String type;
  String form;
  int sum;
  String note;

  OperationApi(
      {required this.id,
        required this.action,
        required this.date,
        required this.type,
        required this.form,
        required this.sum,
        required this.note});

  static OperationApi fromJson(json) => OperationApi(
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
}