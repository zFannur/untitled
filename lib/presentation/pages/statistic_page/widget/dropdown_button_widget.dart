import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/operation.dart';
import '../../../bloc/statistic_bloc/statistic_bloc.dart';

class DropdownButtonWidget extends StatelessWidget {
  final List<String> list;
  final OperationModelFormType type;
  final String text;

  const DropdownButtonWidget(
      {super.key, required this.list, required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    final statisticBloc = context.watch<StatisticBloc>();
    return Column(
      children: [
        Text(text),
        SizedBox(
          width: 100,
          height: 35,
          child: DropdownButton<String>(
            isExpanded: true,
            iconSize: 20,
            alignment: Alignment.topCenter,
            value: type == OperationModelFormType.date
                ? statisticBloc.state.selectedDate
                : type == OperationModelFormType.type
                ? statisticBloc.state.selectedType
                : type == OperationModelFormType.note
                ? statisticBloc.state.selectedNote
                : 'error',
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.green, fontSize: 18),
            underline: Container(
              height: 2,
              color: Colors.lightGreen,
            ),
            onChanged: (String? value) {
              switch (type) {
                case OperationModelFormType.date:
                  statisticBloc.add(ChangeStatisticEvent(selectedDate: value!));
                  break;
                case OperationModelFormType.type:
                  statisticBloc.add(ChangeStatisticEvent(selectedType: value!));
                  break;
                case OperationModelFormType.form:
                  statisticBloc.add(ChangeStatisticEvent(selectedForm: value!));
                  break;
                case OperationModelFormType.note:
                  statisticBloc.add(ChangeStatisticEvent(selectedNote: value!));
                  break;
              }
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}