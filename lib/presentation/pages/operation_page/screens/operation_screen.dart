import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:untitled/resource/langs/locale_keys.g.dart';

import '../../../bloc/operation_bloc/operation_bloc.dart';
import '../../../bloc/operation_change_bloc/operation_change_bloc.dart';
import '../../../navigation/navigation.dart';
import '../../../widget/shimmer_button.dart';

class OperationScreen extends StatelessWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        if (operationBloc.state.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          const _ListOperationsWidget(),
        ShimmerButton(
          onPressed: () {
            context.read<OperationChangeBloc>().add(
                  ChangeOperationEvent(
                    date: DateTime.now(),
                    type: '',
                    form: '',
                    sum: 0,
                    note: '',
                  ),
                );
            Navigator.of(context).pushNamed(RouteNames.addOperation);
          },
          text: LocaleKeys.operationAdd.tr(),
        ),
      ],
    );
  }
}

class _ListOperationsWidget extends StatelessWidget {
  const _ListOperationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: operationBloc.state.operations.length,
          itemBuilder: (context, index) {
            final operation = operationBloc.state.operations[index];
            DateTime dateTime = dateFormat.parse(operation.date);

            return InkWell(
              onTap: () {
                context.read<OperationChangeBloc>().add(
                      ChangeOperationEvent(
                        index: index,
                        date: dateTime,
                        type: operation.type,
                        form: operation.form,
                        sum: operation.sum,
                        note: operation.note,
                      ),
                    );
                Navigator.of(context).pushNamed(RouteNames.editOperation);
              },
              child: Card(
                child: Row(
                  children: [
                    SizedBox(
                      width: 65,
                      child: Center(
                        child: Text('${dateTime.day}:${dateTime.month}'
                            //operation.date,
                            //'${DateTime.parse(operation.date).day}:${DateTime.parse(operation.date).month}:${DateTime.parse(operation.date).year}',
                            ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            operation.form,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            operation.note,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operation.sum.toString(),
                      ),
                    ),
                    // Expanded(
                    //   child: IconButton(
                    //     // edit button
                    //     onPressed: () {
                    //       context.read<OperationChangeBloc>().add(
                    //             ChangeOperationEvent(
                    //               index: index,
                    //               date: dateTime,
                    //               type: operation.type,
                    //               form: operation.form,
                    //               sum: operation.sum,
                    //               note: operation.note,
                    //             ),
                    //           );
                    //       Navigator.of(context)
                    //           .pushNamed(RouteNames.editOperation);
                    //     },
                    //     icon: const Icon(
                    //       Icons.edit,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: IconButton(
                        // delete button
                        onPressed: () {
                          operationBloc.add(DeleteOperationEvent(
                              index: index, id: operation.id));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                color: operation.type == "Расход"
                    ? Colors.red.shade100
                    : Colors.green.shade100,
              ),
            );
          },
        ),
      ),
    );
  }
}
