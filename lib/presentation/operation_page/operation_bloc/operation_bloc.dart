import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../domain/entity/operation.dart';
import '../../../domain/service/api_service.dart';
import '../../../domain/service/hive_service.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState> {
  final ApiService apiService;
  final HiveService hiveService;
  late final StreamSubscription operationBlocSubscription;

  OperationBloc({required this.apiService, required this.hiveService})
      : super(const OperationState()) {
    on<GetOperationEvent>(_onGetOperationEvent);
    on<SendOperationEvent>(_onSendOperationEvent);
    on<DeleteOperationEvent>(_onDeleteOperationEvent);
    on<AddOperationEvent>(_onAddOperationEvent);
    on<EditOperationEvent>(_onEditOperationEvent);

    operationBlocSubscription = stream.listen((state) {
      List<Operation> cache = hiveService.getCache();

      if (cache.isEmpty && this.state.isSend) return;
      if (cache.isNotEmpty && !this.state.isSend) {
        add(SendOperationEvent(operation: cache[0]));
      }
    });
  }

  _onGetOperationEvent(
      GetOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<Operation> local = [];
    List<Operation> sheet = [];

    try {
      local = hiveService.getOperation();

      final isConnect = await InternetConnectionChecker().hasConnection;
      emit(state.copyWith(internetConnected: isConnect));

      if (isConnect) sheet = await apiService.getOperation();

      if (sheet.isEmpty) {
        emit(state.copyWith(operations: local, isLoading: false));
      } else if (local.length == sheet.length) {
        emit(state.copyWith(operations: local, isLoading: false));
      } else {
        hiveService.deleteAll();
        hiveService.addList(sheet);
        emit(state.copyWith(operations: sheet, isLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }

  _onSendOperationEvent(
      SendOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isSend: true));
    String isSendAnswer;

    try {
      isSendAnswer = await apiService.sendOperation(
        action: event.operation.action,
        id: event.operation.id,
        date: event.operation.date,
        type: event.operation.type,
        form: event.operation.form,
        sum: event.operation.sum,
        note: event.operation.note,
      );
      if (isSendAnswer == 'SUCCESS') hiveService.deleteOperationCache(0);
      emit(state.copyWith(isSendAnswer: isSendAnswer, isSend: false));
    } catch (_) {
      emit(state.copyWith(isSendAnswer: "ERROR", isSend: false));
    }
  }

  _onDeleteOperationEvent(
      DeleteOperationEvent event, Emitter<OperationState> emit) async {
    List<Operation> operations = state.operations;

    emit(state.copyWith(isLoading: true));

    hiveService.deleteOperation(event.index, state.operations.elementAt(event.index).id);
    operations.removeAt(event.index);

    emit(state.copyWith(operations: operations));
    emit(state.copyWith(isLoading: false));
  }

  _onAddOperationEvent(
      AddOperationEvent event, Emitter<OperationState> emit) async {
    List<Operation> operations = state.operations;

    operations.add(event.operation);

    final newId = hiveService.getNewId();
    hiveService.addOperation(
      id: newId,
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );

    emit(state.copyWith(operations: operations));
  }

  _onEditOperationEvent(
      EditOperationEvent event, Emitter<OperationState> emit) async {

  }
}
