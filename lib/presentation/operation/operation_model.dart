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

    if (listEquals(local, sheet)) {
      /*#TODO:сравнение_не_работает_в_будущем_сделать_чтобы_работало*/
      _state.operations = _hiveService.getOperation();
    } else {
      _hiveService.deleteAll();
      _state.operations = await _operationService.getOperation();
      _hiveService.addList(_state.operations);
    }
    notifyListeners();
  }

  void reloadOperationInSheet() async {
    _state.operations.clear();
    _hiveService.deleteAll();
    notifyListeners();
    _state.operations = await _operationService.getOperation();
    _hiveService.addList(_state.operations);
    notifyListeners();
  }

  loadOperation() async {
    List<Operation> cache = _hiveService.getCache();
    _state.operations = _hiveService.getOperation();
    _state = _state.copyWith(statusMessage: (cache.length).toString());
    notifyListeners();

    if (cache.isNotEmpty) {
      _state = _state.copyWith(isSending: true);
      try {
        for (int i = cache.length - 1; i >= 0; i--) {
          final status = await _operationService.sendOperation(
            action: cache[i].action,
            id: cache[i].id,
            date: cache[i].date,
            type: cache[i].type,
            form: cache[i].form,
            sum: cache[i].sum,
            note: cache[i].note,
          );
          print('sendOperationAction: ${cache[i].action} , status: $status');
          if (status == 'SUCCESS') {
            if(i == 0) _state = _state.copyWith(isSending: false);
            _state = _state.copyWith(statusMessage: i.toString());
            _hiveService.deleteOperationCache(i);
            notifyListeners();
          }
        }
      } catch (e) {}
    }
    notifyListeners();
  }

  Future<void> onAddOperationButtonPressed(
      BuildContext context, List<Operation> operations) async {
    await Navigator.of(context)
        .pushNamed('/addOperation', arguments: operations);
    await loadOperation();
  }

  Future<void> onEditOperationButtonPressed(
      {required BuildContext context, required int index}) async {
    final arg = Argument(operations: state.operations, index: index);
    await Navigator.of(context).pushNamed('/editOperation', arguments: arg);
    await loadOperation();
  }

  Future<void> onDeleteButtonPressed(int index, int id) async {
    //_state = _state.copyWith(statusMessage: 'isLoading');
    //notifyListeners();
    _hiveService.deleteOperation(index, id);
    await loadOperation();
  }
}
