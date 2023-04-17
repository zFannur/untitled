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

  Future<DateTime> _selectDate(BuildContext context) async {
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
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<AddOperationModel>();
    DateTime date = DateTime.now();
    TextEditingController controller =
        TextEditingController(text: date.toString());

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
            date = await _selectDate(context);
            controller.text = date.toString();
            model.changeDate(date.toString());
          },
        ),
      ],
    );
  }
}

class _TypeFieldWidget extends StatefulWidget {
  const _TypeFieldWidget({Key? key}) : super(key: key);

  @override
  State<_TypeFieldWidget> createState() => _TypeFieldWidgetState();
}

class _TypeFieldWidgetState extends State<_TypeFieldWidget> {

  Future<String?> _addTypeDialog(BuildContext context, String text) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: text);
        List<String> array = ['1', '2', '3', '4'];
        List<String> filter = array;
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Type'),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
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
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: filter.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(filter[index]),
                                  onTap: () => controller.text = filter[index],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('close'),
              onPressed: () {
                Navigator.of(context).pop(text);
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
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
    TextEditingController _controller = TextEditingController();

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
          controller: _controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.add),
            border: OutlineInputBorder(),
            labelText: 'type of transaction',
          ),
          onTap: () async {
            final String type =
                await _addTypeDialog(context, _controller.text) ?? '';
            model.changeType(type);
            _controller.text = type;
          },
          //onChanged: model.changeType,
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
