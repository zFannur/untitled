import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../../domain/entity/operation.dart';
import '../../../domain/use_case/operation_use_case.dart';

part 'operation_event.dart';

part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState> {
  final OperationUseCase operationUseCase;
  late final StreamSubscription operationBlocSubscription;

  OperationBloc({required this.operationUseCase})
      : super(const OperationState()) {
    on<GetOperationEvent>(_onGetOperationEvent);
    on<SendOperationEvent>(_onSendOperationEvent);
    on<DeleteOperationEvent>(_onDeleteOperationEvent);
    on<AddOperationEvent>(_onAddOperationEvent);
    on<EditOperationEvent>(_onEditOperationEvent);
    on<CheckInternetEvent>(_onCheckInternetEvent);

    operationBlocSubscription = stream.listen((state) {
      List<Operation> cache = operationUseCase.getCache();
      if (!this.state.internetConnected) add(CheckInternetEvent());

      if (cache.isEmpty && this.state.isSend) return;
      if (cache.isNotEmpty &&
          !this.state.isSend &&
          this.state.internetConnected) {
        add(SendOperationEvent(operation: cache[0]));
      }
    });
  }

  @override
  Future<void> close() async {
    operationBlocSubscription.cancel();
    return super.close();
  }

  _onCheckInternetEvent(
      CheckInternetEvent event, Emitter<OperationState> emit) async {
    final isConnect = await InternetConnectionChecker().hasConnection;
    emit(state.copyWith(internetConnected: isConnect));
  }

  _onGetOperationEvent(
      GetOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<Operation> operations = await operationUseCase.getOperation();

    emit(state.copyWith(operations: operations, isLoading: false));
  }

  _onSendOperationEvent(
      SendOperationEvent event, Emitter<OperationState> emit) async {
    List<Operation> cache = operationUseCase.getCache();
    emit(state.copyWith(isSend: true, cacheLength: cache.length));

    await operationUseCase.sendOperation(
      action: event.operation.action,
      id: event.operation.id,
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );

    cache = operationUseCase.getCache();
    emit(state.copyWith(isSend: false, cacheLength: cache.length));
  }

  _onDeleteOperationEvent(
      DeleteOperationEvent event, Emitter<OperationState> emit) async {
    List<Operation> operations = state.operations;

    emit(state.copyWith(isLoading: true));

    operationUseCase.deleteOperation(
        event.index, state.operations.elementAt(event.index).id);
    operations.removeAt(event.index);

    List<Operation> cache = operationUseCase.getCache();

    emit(state.copyWith(
      operations: operations,
      isLoading: false,
      cacheLength: cache.length,
    ));
  }

  _onAddOperationEvent(
      AddOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<Operation> operations = await operationUseCase.addOperation(
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );

    List<Operation> cache = operationUseCase.getCache();

    emit(state.copyWith(
        operations: operations, isLoading: false, cacheLength: cache.length));
  }

  _onEditOperationEvent(
      EditOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<Operation> operations = operationUseCase.editOperation(
      id: event.operation.id,
      index: event.index,
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );

    List<Operation> cache = operationUseCase.getCache();

    emit(state.copyWith(
        operations: operations, isLoading: false, cacheLength: cache.length));
  }
}
