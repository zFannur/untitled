import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/domain/entity/operation.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations'),
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
        onPressed: () async {
          final model = context.read<OperationModel>();
          await Navigator.of(context).pushNamed('/addOperation');
          await model.loadOperation();
        },
        child: const Icon(Icons.add),
      ),
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
                      onPressed: () async {
                        final model = context.read<OperationModel>();
                        final arg = Argument(operations: model.state.operations, index: index);
                        await Navigator.of(context)
                            .pushNamed('/editOperation', arguments: arg);
                        await model.loadOperation();
                      },
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
