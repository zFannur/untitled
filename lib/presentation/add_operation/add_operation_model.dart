import 'package:flutter/material.dart';

import '../../domain/service/hive_service.dart';
import '../../domain/service/operation_service.dart';

class AddOperationModelState {
  final String date;
  final String type;
  final String form;
  final int sum;
  final String note;

  AddOperationModelState({
    required this.date,
    required this.type,
    required this.form,
    required this.sum,
    required this.note,
  });

  AddOperationModelState copyWith({
    String? date,
    String? type,
    String? form,
    int? sum,
    String? note,
  }) {
    return AddOperationModelState(
      date: date ?? this.date,
      type: type ?? this.type,
      form: form ?? this.form,
      sum: sum ?? this.sum,
      note: note ?? this.note,
    );
  }
}

class AddOperationModel extends ChangeNotifier {
  HiveService hiveService = HiveService();
  final _operationService = OperationService();
  var _state = AddOperationModelState(
    date: '',
    type: '',
    form: '',
    sum: 0,
    note: '',
  );

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

  Future<void> onAddButtonPressed() async {
    var statusMessage = '';
    final date = _state.date;
    final type = _state.type;
    final form = _state.form;
    final sum = _state.sum;
    final note = _state.note;

    if (date.isEmpty || type.isEmpty || form.isEmpty || sum.toString().isEmpty) {
      return;
    }
    try {
      hiveService.addOperation(
        date: date,
        type: type,
        form: form,
        sum: sum,
        note: note,
      );
      statusMessage = await _operationService.sendOperation(
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
