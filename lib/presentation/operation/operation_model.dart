import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled/domain/service/hive_service.dart';
import 'package:untitled/domain/service/operation_service.dart';
import '../../domain/entity/operation.dart';

class OperationModelState {
  final bool canSubmit;
  final bool isSending;
  final String statusMessage;
  List<Operation> operations = [];

  OperationModelState({
    required this.canSubmit,
    required this.isSending,
    required this.statusMessage,
    required this.operations,
  });

  OperationModelState copyWith({
    bool? canSubmit,
    bool? isSending,
    String? statusMessage,
    List<Operation>? operations,
  }) {
    return OperationModelState(
      canSubmit: canSubmit ?? this.canSubmit,
      isSending: isSending ?? this.isSending,
      statusMessage: statusMessage ?? this.statusMessage,
      operations: operations ?? this.operations,
    );
  }
}

class OperationModel extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  final _operationService = OperationService();
  var _state = OperationModelState(
    canSubmit: true,
    isSending: false,
    statusMessage: '',
    operations: [],
  );

  OperationModelState get state => _state;

  OperationModel() {
    init();
  }

  init() async {
    List<Operation> local = [];
    List<Operation> sheet = [];

    sheet = await _operationService.getOperation();
    local = _hiveService.getOperation();

    if(listEquals(local,sheet)) { //TODO: сравнение не работает в будущем сделать чтобы работало
      _state.operations = _hiveService.getOperation();
    } else {
      _hiveService.deleteAll();
      _state.operations = await _operationService.getOperation();
      _hiveService.addList(_state.operations);
    }
    notifyListeners();
  }

  loadOperation() async {
    _state.operations = _hiveService.getOperation();
    notifyListeners();
  }

  Future<void> onDeleteButtonPressed(int index, int id) async {
    //_state = _state.copyWith(statusMessage: 'isLoading');
    //notifyListeners();
    _hiveService.deleteOperation(index);
    _state = _state.copyWith(
        statusMessage: await _operationService.deleteOperation(id));
    print(_state.statusMessage);
    await loadOperation();
  }
}
