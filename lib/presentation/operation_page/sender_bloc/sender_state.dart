part of 'sender_bloc.dart';

@JsonSerializable()
class SenderState extends Equatable {
  final List<Operation> operations;
  final bool isLoading;
  final bool isError;

  const SenderState({
    this.operations = const [],
    this.isLoading = false,
    this.isError = false,
  });

  SenderState copyWith({
    List<Operation>? operations,
    bool? isLoading,
    bool? isError,
  }) {
    return SenderState(
      operations: operations ?? this.operations,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  factory SenderState.fromJson(Map<String, dynamic> json) => _$SenderStateFromJson(json);

  Map<String, dynamic> toJson() => _$SenderStateToJson(this);

  @override
  List<Object?> get props => [operations, isLoading, isError];
}
