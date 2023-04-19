import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'operation_model.dart';

class OperationScreen extends StatelessWidget {
  const OperationScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => OperationModel(),
      child: const OperationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<OperationModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations'),
        leading: const _ActionAppBarWidget(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (context
              .select((OperationModel value) => value.state.operations)
              .isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            const _ListOperationsWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            model.onAddOperationButtonPressed(context, model.state.operations),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ActionAppBarWidget extends StatelessWidget {
  const _ActionAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperationModel>();
    return model.state.isSending
        ? Row(
            children: [
              IconButton(
                onPressed: () async {
                  await model.loadOperation();
                },
                icon: const Icon(Icons.file_upload),
              ),
              Text(model.state.statusMessage)
            ],
          )
        : IconButton(
            onPressed: model.reloadOperationInSheet,
            icon: const Icon(Icons.download),
          );
  }
}

class _ListOperationsWidget extends StatelessWidget {
  const _ListOperationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperationModel>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: model.state.operations.length,
            itemBuilder: (context, index) {
              final operation = model.state.operations[index];
              return Card(
                  child: Row(
                children: [
                  SizedBox(
                      width: 65,
                      child: Center(
                        child: Text(
                            '${DateTime.parse(operation.date).day}:${DateTime.parse(operation.date).month}:${DateTime.parse(operation.date).year}'),
                      )),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [Text(operation.type), Text(operation.form)],
                    ),
                  ),
                  Expanded(child: Text(operation.sum.toString())),
                  Expanded(
                    child: IconButton(
                      // edit button
                      onPressed: () => model.onEditOperationButtonPressed(
                          context: context, index: index),
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      // delete button
                      onPressed: () {
                        model.onDeleteButtonPressed(index, operation.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ));
            }),
      ),
    );
  }
}
