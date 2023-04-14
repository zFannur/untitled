import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    final model = context.read<AddOperationModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add operation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: const [
              _DataFieldWidget(),
              SizedBox(height: 10),
              _TypeFieldWidget(),
              SizedBox(height: 10),
              _FormFieldWidget(),
              SizedBox(height: 10),
              _SumFieldWidget(),
              SizedBox(height: 10),
              _NoteFieldWidget(),
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
        TextField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_month),
            border: OutlineInputBorder(),
            labelText: 'date of operation',
          ),
          onChanged: model.changeDate,
        ),
      ],
    );
  }
}

class _TypeFieldWidget extends StatelessWidget {
  const _TypeFieldWidget({Key? key}) : super(key: key);

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
    final model = context.read<AddOperationModel>();
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
        TextField(
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
  const _FormFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
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
        TextField(
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
  const _SumFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
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
        TextField(
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
  const _NoteFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
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
        TextField(
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
