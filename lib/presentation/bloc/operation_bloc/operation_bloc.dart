import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:untitled/domain/use_case/api_use_case.dart';
import 'package:untitled/domain/use_case/hive_use_case.dart';

import '../../../../domain/entity/operation.dart';

part 'operation_event.dart';
part 'operation_state.dart';

class OperationBloc extends Bloc<OperationEvent, OperationState> {
  final ApiUseCase apiService;
  final HiveUseCase hiveService;
  late final StreamSubscription operationBlocSubscription;

  OperationBloc({required this.apiService, required this.hiveService})
      : super(const OperationState()) {
    on<GetOperationEvent>(_onGetOperationEvent);
    on<SendOperationEvent>(_onSendOperationEvent);
    on<DeleteOperationEvent>(_onDeleteOperationEvent);
    on<AddOperationEvent>(_onAddOperationEvent);
    on<EditOperationEvent>(_onEditOperationEvent);
    on<CheckInternetEvent>(_onCheckInternetEvent);

    operationBlocSubscription = stream.listen((state) {
      List<Operation> cache = hiveService.getCache();
      if (!this.state.internetConnected) add(CheckInternetEvent());

      if (cache.isEmpty && this.state.isSend) return;
      if (cache.isNotEmpty && !this.state.isSend && this.state.internetConnected) {
        add(SendOperationEvent(operation: cache[0]));
      }
    });
  }

  @override
  Future<void> close() async {
    operationBlocSubscription.cancel();
    return super.close();
  }

  Future<List<Operation>> _onSortOperation(List<Operation> filter) async {
    //DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");

    if(filter.isNotEmpty) {
      int high = filter.length - 1;
      int low = 0;

      filter = quickSort(filter, low, high);
    }
    return filter;
  }

  List<Operation> quickSort(List<Operation> list, int low, int high) {

    if (low < high) {
      int pi = partition(list, low, high);
      quickSort(list, low, pi - 1);
      quickSort(list, pi + 1, high);
    }
    return list;
  }

  int partition(List<Operation> list, low, high) {

    if (list.isEmpty) {
      return 0;
    }

    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    int pivot = dateFormat
        .parse(list[high].date).millisecondsSinceEpoch;
    int i = low - 1;
    for (int j = low; j < high; j++) {
      if (dateFormat
          .parse(list[j].date).millisecondsSinceEpoch > pivot) {
        i++;
        swap(list, i, j);
      }
    }
    swap(list, i + 1, high);
    return i + 1;
  }

  void swap(List list, int i, int j) {
    Operation temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }

  _onCheckInternetEvent(
      CheckInternetEvent event, Emitter<OperationState> emit) async {
    final isConnect = await InternetConnectionChecker().hasConnection;
    emit(state.copyWith(internetConnected: isConnect));
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
        emit(state.copyWith(operations: await _onSortOperation(local), isLoading: false));
      } else if (local.length == sheet.length) {
        emit(state.copyWith(operations: await _onSortOperation(local), isLoading: false));
      } else {
        await hiveService.deleteAll();
        await hiveService.addList(sheet);
        emit(state.copyWith(operations: await _onSortOperation(sheet), isLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isError: true, isLoading: false));
    }

    //add(SortOperationEvent());
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
      List<Operation> cache = hiveService.getCache();
      emit(state.copyWith(isSendAnswer: isSendAnswer, isSend: false, cacheLength: cache.length));
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

    List<Operation> cache = hiveService.getCache();


    emit(state.copyWith(operations: operations, isLoading: false, cacheLength: cache.length));
  }

  _onAddOperationEvent(
      AddOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));

    final newId = hiveService.getNewId();
    hiveService.addOperation(
      id: newId,
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );

    List<Operation> local = hiveService.getOperation();
    List<Operation> cache = hiveService.getCache();
    emit(state.copyWith(operations: await _onSortOperation(local), isLoading: false, cacheLength: cache.length));
  }

  _onEditOperationEvent(
      EditOperationEvent event, Emitter<OperationState> emit) async {
    emit(state.copyWith(isLoading: true));
    hiveService.editOperation(
      id: event.operation.id,
      index: event.index,
      date: event.operation.date,
      type: event.operation.type,
      form: event.operation.form,
      sum: event.operation.sum,
      note: event.operation.note,
    );
    List<Operation> local = hiveService.getOperation();
    List<Operation> cache = hiveService.getCache();

    emit(state.copyWith(operations: await _onSortOperation(local), isLoading: false, cacheLength: cache.length));
  }
}
