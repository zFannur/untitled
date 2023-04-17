import 'dart:async';

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
    final operation = arg.operation;
    final index = arg.index;

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
              ),
              const SizedBox(height: 10),
              _FormFieldWidget(
                form: operation.form,
              ),
              const SizedBox(height: 10),
              _SumFieldWidget(
                sum: operation.sum,
              ),
              const SizedBox(height: 10),
              _NoteFieldWidget(
                note: operation.note,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date *',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            initialValue: date,
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
                labelText: 'date of operation',
                helperText: date),
            onChanged: model.changeDate),
      ],
    );
  }
}

class _TypeFieldWidget extends StatelessWidget {
  final String type;

  const _TypeFieldWidget({Key? key, required this.type}) : super(key: key);

  Future<void> _addTypeDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Type'),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  height: 4,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          child: ListTile(
                            title: Text('1'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type *',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: type,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'type of transaction',
          ),
          onChanged: model.changeType,
          //onTap: () async => await _addTypeDialog(context),
        ),
      ],
    );
  }
}

class _FormFieldWidget extends StatelessWidget {
  String form;

  _FormFieldWidget({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Form *',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: form,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'Form',
          ),
          onChanged: model.changeForm,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sum *',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: sum.toString(),
          decoration: InputDecoration(
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
  final String note;

  const _NoteFieldWidget({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<EditOperationModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Note',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          initialValue: note,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'note',
          ),
          onChanged: model.changeNote,
        ),
      ],
    );
  }
}