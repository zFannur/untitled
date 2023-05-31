part of 'operation_change_bloc.dart';

class OperationChangeState extends Equatable {
  final int index;
  final String date;
  final String type;
  final String form;
  final int sum;
  final String note;

  const OperationChangeState({
    this.index = 0,
    this.date = '',
    this.type = '',
    this.form = '',
    this.sum = 0,
    this.note = '',
  });

  OperationChangeState copyWith({
    int? index,
    String? date,
    String? type,
    String? form,
    int? sum,
    String? note,
  }) {
    return OperationChangeState(
      index: index ?? this.index,
      date: date ?? this.date,
      type: type ?? this.type,
      form: form ?? this.form,
      sum: sum ?? this.sum,
      note: note ?? this.note,
    );
  }

  @override
// TODO: implement props
  List<Object?> get props => [index, date, type, form, sum, note];
}
