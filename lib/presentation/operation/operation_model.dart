import 'package:flutter/cupertino.dart';
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
    loadOperation();
  }

  loadOperation() async {
    _state.operations = _hiveService.getOperation();
    if (_state.operations.isEmpty) {
      _state.operations = await _operationService.getOperation();
      _hiveService.addList(_state.operations);
    }
    notifyListeners();
  }

  Future<void> onDeleteButtonPressed(int index, int id) async {
    //_state = _state.copyWith(statusMessage: 'isLoading');
    //notifyListeners();
    _hiveService.deleteOperation(index);
    _state = _state.copyWith(
        statusMessage: await _operationService.deleteOperation(id));
    print(_state.statusMessage);
  }

  Future<void> onEditButtonPressed(int id) async {
    //_state = _state.copyWith(statusMessage: 'isLoading');
    //notifyListeners();
    //_state = _state.copyWith(statusMessage: await _operationService.deleteOperation(id));
    loadOperation();
  }
}
