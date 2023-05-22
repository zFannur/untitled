import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/presentation/navigation/navigation.dart';
import '../../domain/entity/operation.dart';
import '../../domain/service/api_service.dart';
import '../../domain/service/hive_service.dart';

class OperationModelState {
  final bool internetStatus;
  final bool isSending;
  final String statusMessage;
  List<Operation> operations = [];

  OperationModelState({
    required this.internetStatus,
    required this.isSending,
    required this.statusMessage,
    required this.operations,
  });

  OperationModelState copyWith({
    bool? internetStatus,
    bool? canSubmit,
    bool? isSending,
    String? statusMessage,
    List<Operation>? operations,
  }) {
    return OperationModelState(
      internetStatus: internetStatus ?? this.internetStatus,
      isSending: isSending ?? this.isSending,
      statusMessage: statusMessage ?? this.statusMessage,
      operations: operations ?? this.operations,
    );
  }
}

class OperationModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final _operationService = ApiService();
  var _state = OperationModelState(
    internetStatus: false,
    isSending: false,
    statusMessage: '',
    operations: [],
  );

  OperationModelState get state => _state;

  OperationModel() {
    init();
  }

  Future<void> init() async {
    List<Operation> local = [];
    List<Operation> sheet = [];

    try {
      local = _hiveService.getOperation();
      final result = await InternetConnectionChecker().hasConnection;
      _state = _state.copyWith(internetStatus: result);
      print('intersetStatus: $result');

      if (_state.internetStatus) sheet = await _operationService.getOperation();
    } catch (e) {
      print(e);
    }

    if (local.length == sheet.length || sheet.isEmpty) {
      // TODO: сравнение не работает в будущем сделать чтобы работало
      _state.operations = _hiveService.getOperation();
    } else {
      _hiveService.deleteAll();
      _state.operations = await _operationService.getOperation();
      _hiveService.addList(_state.operations);
    }
    notifyListeners();
  }

  void reloadOperationInSheet() async {
    final result = await InternetConnectionChecker().hasConnection;
    _state = _state.copyWith(internetStatus: result);

    notifyListeners();
    if (_state.internetStatus) {
      _state.operations.clear();
      _hiveService.deleteAll();
      _state.operations = await _operationService.getOperation();
      _hiveService.addList(_state.operations);
    }

    notifyListeners();
  }

  Future<void> loadOperation() async {
    final result = await InternetConnectionChecker().hasConnection;
    _state = _state.copyWith(internetStatus: result);

    List<Operation> cache = _hiveService.getCache();
    _state.operations = _hiveService.getOperation();
    _state = _state.copyWith(statusMessage: (cache.length).toString());
    notifyListeners();
    if (!_state.isSending) {
      if (cache.isNotEmpty) _state = _state.copyWith(isSending: true);
      notifyListeners();

      if (cache.isNotEmpty && _state.internetStatus) {
        try {
          for (int i = cache.length - 1; i >= 0; i--) {
            await _operationService
                .sendOperation(
              action: cache[i].action,
              id: cache[i].id,
              date: cache[i].date,
              type: cache[i].type,
              form: cache[i].form,
              sum: cache[i].sum,
              note: cache[i].note,
            )
                .then((value) {
              print('sendOperationAction: ${cache[i].action} , status: ${value
                  .characters.string}');
              if (value.characters.string == 'SUCCESS') {
                _state = _state.copyWith(statusMessage: i.toString());
                _hiveService.deleteOperationCache(i);
                notifyListeners();
              }
            });
          }
          _state = _state.copyWith(isSending: false);
        } catch (e) {
          print(e);
        }
      }
      notifyListeners();
    }
  }

  Future<void> onAddOperationButtonPressed(
      BuildContext context, List<Operation> operations) async {
    await Navigator.of(context)
        .pushNamed(RouteNames.addOperation, arguments: operations);
    await loadOperation();
  }

  Future<void> onEditOperationButtonPressed(
      {required BuildContext context, required int index}) async {
    final arg = Argument(operations: state.operations, index: index);
    await Navigator.of(context).pushNamed(RouteNames.editOperation, arguments: arg);
    await loadOperation();
  }

  Future<void> onDeleteButtonPressed(int index, int id) async {
    //_state = _state.copyWith(statusMessage: 'isLoading');
    //notifyListeners();
    _hiveService.deleteOperation(index, id);
    await loadOperation();
  }
}
