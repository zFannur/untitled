import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:untitled/presentation/bloc/statistic_bloc/statistic_bloc.dart';
import '../../../../domain/entity/operation.dart';
import '../../../bloc/operation_bloc/operation_bloc.dart';

class FilteredOperations {
  final int summa;
  final String type;

  const FilteredOperations({this.summa = 0, this.type = ''});
}

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return Column(
      children: [
        if (operationBloc.state.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          const SizedBox(
            width: 400,
            height: 600,
            child: _StatisticListWidget(),
          ),
      ],
    );
  }
}

class _StatisticListWidget extends StatelessWidget {
  const _StatisticListWidget({Key? key}) : super(key: key);

  List<FilteredOperations> _sumType(List<Operation> operations, StatisticBloc statisticBloc) {
    List<String> filter = [];
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    List<FilteredOperations> filteredOperations = [];
    int summ = 0;

    var uniquesNames = <String, bool>{};
    for (var s in operations) {
      uniquesNames[s.form] = true;
    }
    for (var key in uniquesNames.keys) {
      filter.add(key);
    }

    for (int i = 0; i < filter.length; i++) {
      summ = 0;
      for (int j = 0; j < operations.length; j++) {
        if (filter[i] == operations[j].form && statisticBloc.state.dropdownValue.toString() == dateFormat.parse(operations[j].date).month.toString()) {
          summ += operations[j].sum;
        }
      }
      filteredOperations.add(FilteredOperations(summa: summ, type: filter[i]));
    }
    return filteredOperations;
  }

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    final statisticBloc = context.watch<StatisticBloc>();
    List<FilteredOperations> filteredOperations =
        _sumType(operationBloc.state.operations, statisticBloc);
    return Column(
      children: [
        const DropdownButtonExample(),
        Expanded(
          child: ListView.builder(
            itemCount: filteredOperations.length,
            itemBuilder: (context, index) {
              return Container(
                color: index % 2 == 0 ? Colors.white : Colors.white10,
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(filteredOperations[index].type),
                    Text(filteredOperations[index].summa.toString()),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DropdownButtonExample extends StatelessWidget {
  const DropdownButtonExample({super.key});
  final List<String> month = const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];

  @override
  Widget build(BuildContext context) {
    final statisticBloc = context.watch<StatisticBloc>();
    return DropdownButton<String>(
      value: statisticBloc.state.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
          statisticBloc.add(ChangeStatisticEvent(dropdownValue: value!));
      },
      items: month.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
