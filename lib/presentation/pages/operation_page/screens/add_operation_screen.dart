import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/domain/entity/operation.dart';
import '../../../bloc/operation_bloc/operation_bloc.dart';
import '../../../bloc/operation_change_bloc/operation_change_bloc.dart';
import '../widgets/AlertDialogWidget.dart';

class AddOperationScreen extends StatelessWidget {
  const AddOperationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.read<OperationBloc>();
    final operationChangeBloc = context.watch<OperationChangeBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add operation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (operationChangeBloc.state.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  children: [
                    const _DataFieldWidget(),
                    const SizedBox(height: 10),
                    _FieldWidget(
                      textFieldText: operationChangeBloc.state.type,
                      nameText: 'Type',
                      labelText: 'type of transaction',
                      formType: OperationModelFormType.type,
                    ),
                    const SizedBox(height: 10),
                    _FieldWidget(
                      textFieldText: operationChangeBloc.state.form,
                      nameText: 'Form',
                      labelText: 'form of transaction',
                      formType: OperationModelFormType.form,
                    ),
                    const SizedBox(height: 10),
                    const _SumFieldWidget(),
                    const SizedBox(height: 10),
                    _FieldWidget(
                      textFieldText: operationChangeBloc.state.note,
                      nameText: 'Note',
                      labelText: 'note of transaction',
                      formType: OperationModelFormType.note,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String formattedDate = DateFormat('dd.MM.yyyy kk:mm:ss').format(operationChangeBloc.state.date);
          Operation result = Operation(
            id: 0,
            action: 'add',
            date: formattedDate,
            type: operationChangeBloc.state.type,
            form: operationChangeBloc.state.form,
            sum: operationChangeBloc.state.sum,
            note: operationChangeBloc.state.note,
          );
          operationBloc.add(AddOperationEvent(
              operation: result));
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DataFieldWidget extends StatelessWidget {
  const _DataFieldWidget({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final operationChangeBloc = context.read<OperationChangeBloc>();

    TextEditingController controller =
    TextEditingController(text: operationChangeBloc.state.date.toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date *',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            border: OutlineInputBorder(),
            labelText: 'date of operation',
          ),
          onTap: () async {
            DateTime date = await selectDate(context);
            controller.text = date.toString();
            operationChangeBloc
                .add(ChangeOperationEvent(date: date));
          },
        ),
      ],
    );
  }
}

class _FieldWidget extends StatelessWidget {
  final String textFieldText;
  final String nameText;
  final String labelText;
  final OperationModelFormType formType;

  const _FieldWidget({
    Key? key,
    required this.textFieldText,
    required this.nameText,
    required this.labelText,
    required this.formType,
  }) : super(key: key);

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
          case OperationModelFormType.date:
            break;
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

        return AlertDialogWidget(
          filter: filter,
          operationsItems: filtered,
          controller: controller,
          text: text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final operationChangeBloc = context.watch<OperationChangeBloc>();

    TextEditingController controller = TextEditingController(
      text: textFieldText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nameText,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.add),
            border: const OutlineInputBorder(),
            labelText: labelText,
          ),
          onTap: () async {
            final operationBloc = context.read<OperationBloc>();
            final selectedText = await addDialog(
              context: context,
              text: controller.text,
              operations: operationBloc.state.operations,
              type: formType,
            ) ??
                '';
            switch (formType) {
              case OperationModelFormType.date:
                break;
              case OperationModelFormType.type:
                operationChangeBloc
                    .add(ChangeOperationEvent(type: selectedText));
                break;
              case OperationModelFormType.form:
                operationChangeBloc
                    .add(ChangeOperationEvent(form: selectedText));
                break;
              case OperationModelFormType.note:
                operationChangeBloc
                    .add(ChangeOperationEvent(note: selectedText));
                break;
            }
            controller.text = selectedText;
          },
        ),
      ],
    );
  }
}

class _SumFieldWidget extends StatelessWidget {
  const _SumFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationChangeBloc = context.read<OperationChangeBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sum *',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          initialValue: operationChangeBloc.state.sum.toString(),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.money),
            border: OutlineInputBorder(),
            labelText: 'sum',
          ),
          onChanged: (value) {
            operationChangeBloc
                .add(ChangeOperationEvent(sum: int.tryParse(value)));
          },
        ),
      ],
    );
  }
}
