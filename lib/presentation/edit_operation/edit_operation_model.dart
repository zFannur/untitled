import 'package:flutter/material.dart';

import '../../domain/service/hive_service.dart';
import '../../domain/service/operation_service.dart';

class EditOperationModelState {
  final String date;
  final String type;
  final String form;
  final int sum;
  final String note;

  EditOperationModelState({
    required this.date,
    required this.type,
    required this.form,
    required this.sum,
    required this.note,
  });

  EditOperationModelState copyWith({
    String? date,
    String? type,
    String? form,
    int? sum,
    String? note,
  }) {
    return EditOperationModelState(
      date: date ?? this.date,
      type: type ?? this.type,
      form: form ?? this.form,
      sum: sum ?? this.sum,
      note: note ?? this.note,
    );
  }
}

class EditOperationModel extends ChangeNotifier {
  HiveService hiveService = HiveService();
  final _operationService = OperationService();
  var _state = EditOperationModelState(
    date: '',
    type: '',
    form: '',
    sum: 0,
    note: '',
  );

  void changeEditState({
    required String? date,
    required String type,
    required String form,
    required int sum,
    required String note,
  }) {
    _state = _state.copyWith(date: date ?? DateTime.now().toString());
    _state = _state.copyWith(type: type);
    _state = _state.copyWith(form: form);
    _state = _state.copyWith(sum: sum);
    _state = _state.copyWith(note: note);
  }

  void changeDate(String value) {
    if (_state.date == value) return;
    _state = _state.copyWith(date: DateTime.now().toString());
    notifyListeners();
  }

  void changeType(String value) {
    if (_state.type == value) return;
    _state = _state.copyWith(type: value);
    notifyListeners();
  }

  void changeForm(String value) {
    if (_state.form == value) return;
    _state = _state.copyWith(form: value);
    notifyListeners();
  }

  void changeSum(String value) {
    if (_state.sum == int.tryParse(value)) return;
    _state = _state.copyWith(sum: int.tryParse(value));
    notifyListeners();
  }

  void changeNote(String value) {
    if (_state.note == value) return;
    _state = _state.copyWith(note: value);
    notifyListeners();
  }

  Future<void> onEditButtonPressed(int index, int id) async {
    var statusMessage = '';
    final date = _state.date;
    final type = _state.type;
    final form = _state.form;
    final sum = _state.sum;
    final note = _state.note;

    try {
      final newId = hiveService.getNewId();
      //_state = _state.copyWith(statusMessage: 'isLoading');
      //notifyListeners();
      hiveService.editOperation(
        id: id,
        index: index,
        date: date,
        type: type,
        form: form,
        sum: sum,
        note: note,
      );
      statusMessage = await _operationService.editOperation(
        id: id,
        date: date,
        type: type,
        form: form,
        sum: sum,
        note: note,
      );
    } catch (e) {
      statusMessage = 'Ошибка';
    }
    print(statusMessage);
  }
}
