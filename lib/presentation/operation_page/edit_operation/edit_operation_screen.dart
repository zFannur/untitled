import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/domain/entity/operation.dart';
import 'edit_operation_model.dart';

class EditOperationScreen extends StatelessWidget {
  const EditOperationScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => EditOperationModel(),
      child: const EditOperationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    final arg = ModalRoute.of(context)!.settings.arguments as Argument;
    final index = arg.index;
    final operation = arg.operations[index];
    final operations = arg.operations;

    model.changeEditState(
      date: operation.date,
      type: operation.type,
      form: operation.form,
      sum: operation.sum,
      note: operation.note,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit operation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _DataFieldWidget(date: operation.date),
              const SizedBox(height: 10),
              _TypeFieldWidget(
                type: operation.type,
                operations: operations,
              ),
              const SizedBox(height: 10),
              _FormFieldWidget(
                form: operation.form,
                operations: operations,
              ),
              const SizedBox(height: 10),
              _SumFieldWidget(
                sum: operation.sum,
              ),
              const SizedBox(height: 10),
              _NoteFieldWidget(
                note: operation.note,
                operations: operations,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.onEditButtonPressed(index, operation.id);
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DataFieldWidget extends StatelessWidget {
  final String date;

  const _DataFieldWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    DateTime date = DateTime.now();
    TextEditingController controller =
        TextEditingController(text: date.toString());
    model.changeDate(date, false);
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
            date = await model.selectDate(context);
            controller.text = date.toString();
            model.changeDate(date, true);
          },
        ),
      ],
    );
  }
}

class _TypeFieldWidget extends StatelessWidget {
  final String type;
  final List<Operation> operations;

  const _TypeFieldWidget(
      {Key? key, required this.type, required this.operations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: type);
    final model = context.read<EditOperationModel>();
    model.changeType(type, false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type *',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'type of transaction',
          ),
          onTap: () async {
            final type = await model.addDialog(
              context: context,
              text: controller.text,
              operations: operations,
              type: OperationModelFormType.type,
            ) ?? '';
            model.changeType(type, true);
            controller.text = type;
          },
        ),
      ],
    );
  }
}

class _FormFieldWidget extends StatelessWidget {
  final String form;
  final List<Operation> operations;

  const _FormFieldWidget({Key? key, required this.form, required this.operations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    TextEditingController controller = TextEditingController(text: form);
    model.changeForm(form, false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Form *',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'Form',
          ),
          onTap: () async {
            final form = await model.addDialog(
              context: context,
              text: controller.text,
              operations: operations,
              type: OperationModelFormType.form,
            ) ?? '';
            model.changeForm(form, true);
            controller.text = form;
          },
        ),
      ],
    );
  }
}

class _SumFieldWidget extends StatelessWidget {
  final int sum;

  const _SumFieldWidget({Key? key, required this.sum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    model.changeSum(sum.toString(), false);
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
          initialValue: sum.toString(),
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.money),
            border: OutlineInputBorder(),
            labelText: 'sum',
          ),
          onChanged: (value) {
            model.changeSum(value, true);
          },
        ),
      ],
    );
  }
}

class _NoteFieldWidget extends StatelessWidget {
  final String note;
  final List<Operation> operations;

  const _NoteFieldWidget(
      {Key? key, required this.note, required this.operations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    TextEditingController controller = TextEditingController(text: note);
    model.changeForm(note, false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'note',
          ),
          onTap: () async {
            final note = await model.addDialog(
              context: context,
              text: controller.text,
              operations: operations,
              type: OperationModelFormType.note,
            ) ?? '';
            model.changeForm(note, true);
            controller.text = note;
          },
        ),
      ],
    );
  }
}
