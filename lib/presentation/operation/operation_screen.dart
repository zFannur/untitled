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
            const CircularProgressIndicator()
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
      child: ListView.builder(
          itemCount: model.state.operations.length,
          itemBuilder: (context, index) {
            final operation = model.state.operations[index];
            return Card(
                child: Row(
              children: [
                Expanded(child: Text(operation.date)),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [Text(operation.type), Text(operation.form)],
                  ),
                ),
                Expanded(child: Text(operation.sum.toString())),
                Expanded(
                  child: IconButton(
                    onPressed: () async {
                      // final model = context.read<OperationModel>();
                      // await Navigator.of(context).pushNamed('/addOperation');
                      // await model.loadOperation();
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () async {
                      model.onDeleteButtonPressed(index, operation.id);
                      await model.loadOperation();
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
    );
  }
}
