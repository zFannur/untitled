part of 'operation_change_bloc.dart';

abstract class OperationChangeEvent extends Equatable {
  const OperationChangeEvent();
}

class ChangeIndexEvent extends OperationChangeEvent {
  final int index;

  const ChangeIndexEvent(this.index);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ChangeDateEvent extends OperationChangeEvent {
  final int index;

  const ChangeDateEvent(this.index);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ChangeOperationEvent extends OperationChangeEvent {
  final int? index;
  final DateTime? date;
  final String? type;
  final String? form;
  final int? sum;
  final String? note;

  const ChangeOperationEvent({
    this.index,
    this.date,
    this.type,
    this.form,
    this.sum,
    this.note,
  });

  @override
  List<Object?> get props => [index, date,type, form, sum, note];
}
