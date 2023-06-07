part of 'operation_change_bloc.dart';

class OperationChangeState extends Equatable {
  final bool isLoading;
  final int index;
  final DateTime date;
  final String type;
  final String form;
  final int sum;
  final String note;

  const OperationChangeState({
    this.isLoading = false,
    this.index = 0,
    this.date = const ConstDateTime(2023),
    this.type = '',
    this.form = '',
    this.sum = 0,
    this.note = '',
  });

  OperationChangeState copyWith({
    bool? isLoading,
    int? index,
    DateTime? date,
    String? type,
    String? form,
    int? sum,
    String? note,
  }) {
    return OperationChangeState(
      isLoading: isLoading ?? this.isLoading,
      index: index ?? this.index,
      date: date ?? this.date,
      type: type ?? this.type,
      form: form ?? this.form,
      sum: sum ?? this.sum,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [index, date, type, form, sum, note];
}
