import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/domain/entity/operation.dart';
import 'package:untitled/presentation/add_operation/add_operation_model.dart';

class AddOperationScreen extends StatelessWidget {
  const AddOperationScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => AddOperationModel(),
      child: const AddOperationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final operations =
        ModalRoute.of(context)!.settings.arguments as List<Operation>;
    final model = context.read<AddOperationModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add operation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const _DataFieldWidget(),
              const SizedBox(height: 10),
              _TypeFieldWidget(operations: operations),
              const SizedBox(height: 10),
              _FormFieldWidget(operations: operations),
              const SizedBox(height: 10),
              const _SumFieldWidget(),
              const SizedBox(height: 10),
              _NoteFieldWidget(operations: operations),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          model.onAddButtonPressed();
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DataFieldWidget extends StatelessWidget {
  const _DataFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
    DateTime date = DateTime.now();
    TextEditingController controller =
        TextEditingController(text: date.toString());
    model.changeDate(date.toString(), false);

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
            model.changeDate(date.toString(), true);
          },
        ),
      ],
    );
  }
}

class _TypeFieldWidget extends StatelessWidget {
  List<Operation> operations;

  _TypeFieldWidget({Key? key, required this.operations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
    TextEditingController controller = TextEditingController();

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
            model.changeType(type);
            controller.text = type;
          },
          //onChanged: model.changeType,
          //onTap: () async => await _addTypeDialog(context),
        ),
      ],
    );
  }
}

class _FormFieldWidget extends StatelessWidget {
  List<Operation> operations;
  _FormFieldWidget({Key? key, required this.operations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
    TextEditingController controller = TextEditingController();
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
            model.changeForm(form);
            controller.text = form;
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
    final model = context.read<AddOperationModel>();
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
        TextField(
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.money),
            border: OutlineInputBorder(),
            labelText: 'sum',
          ),
          onChanged: model.changeSum,
        ),
      ],
    );
  }
}

class _NoteFieldWidget extends StatelessWidget {
  List<Operation> operations;
  _NoteFieldWidget({Key? key, required this.operations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
    TextEditingController controller = TextEditingController();
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
            model.changeNote(note);
            controller.text = note;
          },
        ),
      ],
    );
  }
}
