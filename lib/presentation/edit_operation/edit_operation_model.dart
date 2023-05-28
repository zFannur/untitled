import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/operation.dart';
import '../../domain/service/hive_service.dart';

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

  void changeDate(DateTime dateTime, bool notifyListener) {
    if (_state.date == dateTime.toString()) return;
    String formattedDate = DateFormat('dd.MM.yyyy kk:mm:ss').format(dateTime);
    _state = _state.copyWith(date: formattedDate);
    if (notifyListener){
      notifyListeners();
    }
  }

  void changeType(String value, bool notifyListener) {
    if (_state.type == value) return;
    _state = _state.copyWith(type: value);
    if (notifyListener){
      notifyListeners();
    }
  }

  void changeForm(String value, bool notifyListener) {
    if (_state.form == value) return;
    _state = _state.copyWith(form: value);
    if (notifyListener){
      notifyListeners();
    }
  }

  void changeSum(String value, bool notifyListener) {
    if (_state.sum == int.tryParse(value)) return;
    _state = _state.copyWith(sum: int.tryParse(value));
    if (notifyListener){
      notifyListeners();
    }
  }

  void changeNote(String value, bool notifyListener) {
    if (_state.note == value) return;
    _state = _state.copyWith(note: value);
    if (notifyListener){
      notifyListeners();
    }
  }

  Future<void> onEditButtonPressed(int index, int id) async {
    var statusMessage = '';
    final date = _state.date;
    final type = _state.type;
    final form = _state.form;
    final sum = _state.sum;
    final note = _state.note;

    try {
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
      // statusMessage = await _operationService.editOperation(
      //   id: id,
      //   date: date,
      //   type: type,
      //   form: form,
      //   sum: sum,
      //   note: note,
      // );
    } catch (e) {
      statusMessage = 'Ошибка';
    }
    print(statusMessage);
  }

  Future<DateTime> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != selectedDate) {
      selectedDate = selected;
    }
    return selectedDate.copyWith(hour: 12, minute: 12, second: 12);
  }

  Future<String?> addDialog({
    required BuildContext context,
    required String text,
    required List<Operation> operations,
    required OperationModelFormType type,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: text);
        List<String> filter = [];
        List<String> filtered = [];

        switch (type) {
          case OperationModelFormType.type:
            var uniques = <String, bool>{};
            for (var s in operations) {
              uniques[s.type] = true;
            }
            for (var key in uniques.keys) {
              filter.add(key);
              filtered.add(key);
            }
            break;
          case OperationModelFormType.form:
            var uniques = <String, bool>{};
            for (var s in operations) {
              uniques[s.form] = true;
            }
            for (var key in uniques.keys) {
              filter.add(key);
              filtered.add(key);
            }
            break;
          case OperationModelFormType.note:
            var uniques = <String, bool>{};
            for (var s in operations) {
              uniques[s.note] = true;
            }
            for (var key in uniques.keys) {
              filter.add(key);
              filtered.add(key);
            }
            break;
        }
        //filtered = filter;

        return _AlertDialogWidget(
          filter: filter,
          operationsItems: filtered,
          controller: controller,
          text: text,
        );
      },
    );
  }
}

class _AlertDialogWidget extends StatefulWidget {
  final List<String> filter;
  final String text;
  final TextEditingController controller;
  final List<String> operationsItems;

  const _AlertDialogWidget({
    Key? key,
    required this.filter,
    required this.operationsItems,
    required this.controller,
    required this.text,
  }) : super(key: key);

  @override
  State<_AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<_AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 300,
        child: Column(
          children: [
            const Text('Type'),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                widget.filter.clear();
                if (value.isEmpty) {
                  widget.filter.clear();
                  widget.filter.addAll(widget.operationsItems);
                }
                for (final item in widget.operationsItems) {
                  if (item.toLowerCase().contains(value.toLowerCase())) {
                    widget.filter.add(item);
                  }
                }

                setState(() {});
              },
              keyboardType: TextInputType.text,
              controller: widget.controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 4,
              color: Colors.black,
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.filter.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(widget.filter[index]),
                        onTap: () =>
                            Navigator.of(context).pop(widget.filter[index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('close'),
          onPressed: () {
            Navigator.of(context).pop(widget.text);
          },
        ),
        ElevatedButton(
          child: const Text('Add'),
          onPressed: () {
            Navigator.of(context).pop(widget.controller.text);
          },
        ),
      ],
    );
  }
}
