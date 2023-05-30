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

  OperationBloc({required this.apiService, required this.hiveService}) : super(const OperationState()) {
    on<GetOperationEvent>(_onGetOperationEvent);
    on<SendOperationEvent>(_onSendOperationEvent);
    on<DeleteOperationEvent>(_onDeleteOperationEvent);
  }

  _onGetOperationEvent(
      GetOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    List<Operation> local = [];
    List<Operation> sheet = [];

    try {
      local = hiveService.getOperation();

      final isConnect = await InternetConnectionChecker().hasConnection;
      if (isConnect) sheet = await apiService.getOperation();

      if (sheet.isEmpty) {
        emit(state.copyWith(operations: local, isLoading: false));
      } else if(local == sheet) {
        emit(state.copyWith(operations: local, isLoading: false));
      } else {
        hiveService.deleteAll();
        emit(state.copyWith(operations: sheet, isLoading: false));
        hiveService.addList(sheet);
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
      emit(state.copyWith(isSendAnswer: isSendAnswer, isSend: false));
    } catch (_) {
      emit(state.copyWith(isSendAnswer: "ERROR", isSend: false));
    }
  }

  _onDeleteOperationEvent(
      DeleteOperationEvent event, Emitter<OperationState> emit) async {

    hiveService.deleteOperation(event.index, event.id);
  }

  _onAddOperationEvent(
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
      emit(state.copyWith(isSendAnswer: isSendAnswer, isSend: false));
    } catch (_) {
      emit(state.copyWith(isSendAnswer: "ERROR", isSend: false));
    }
  }
}
