part of 'operation_bloc.dart';

abstract class OperationEvent extends Equatable {
  const OperationEvent();
}

class GetOperationEvent extends OperationEvent {
  @override
  List<Object?> get props => [];
}

class SendOperationEvent extends OperationEvent {
  final Operation operation;
  const SendOperationEvent({required this.operation});

  @override
  List<Object?> get props => [operation];
}

class DeleteOperationEvent extends OperationEvent {
  final int index;
  final int id;
  const DeleteOperationEvent({required this.index, required this.id});

  @override
  List<Object?> get props => [index, id];
}

class AddOperationEvent extends OperationEvent {
  final Operation operation;
  const AddOperationEvent({required this.operation});

  @override
  List<Object?> get props => [operation];
}

class EditOperationEvent extends OperationEvent {
  final Operation operation;
  final int index;
  const EditOperationEvent({required this.operation, required this.index});

  @override
  List<Object?> get props => [operation, index];
}
