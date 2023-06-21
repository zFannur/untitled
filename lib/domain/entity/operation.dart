import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation.g.dart';

@JsonSerializable()
class Operation extends Equatable {
  final int id;
  final String action;
  final String date;
  final String type;
  final String form;
  final int sum;
  final String note;

  const Operation({
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

  @override
  List<Object?> get props => [
        id,
        action,
        date,
        type,
        form,
        sum,
        note,
      ];

  factory Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);

  Map<String, dynamic> toJson() => _$OperationToJson(this);
}

enum OperationModelFormType {
  date,
  type,
  form,
  note,
}

class FilteredOperations {
  final int summa;
  final String form;

  const FilteredOperations({this.summa = 0, this.form = ''});
}
