part of 'operation_bloc.dart';

class OperationState extends Equatable {
  final List<Operation> operations;
  final bool isLoading;
  final bool isError;
  final bool isSend;
  final String isSendAnswer;
  final bool internetConnected;

  const OperationState({
    this.operations = const [],
    this.isLoading = false,
    this.isError = false,
    this.isSend = false,
    this.isSendAnswer = '',
    this.internetConnected = false,
  });

  OperationState copyWith({
    List<Operation>? operations,
    bool? isLoading,
    bool? isError,
    bool? isSend,
    bool? internetConnected,
    String? isSendAnswer,
  }) {
    return OperationState(
      operations: operations ?? this.operations,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSend: isSend ?? this.isSend,
      internetConnected: internetConnected ?? this.internetConnected,
    );
  }

  @override
  List<Object?> get props => [operations, isLoading, isError, isSend, internetConnected];
}
