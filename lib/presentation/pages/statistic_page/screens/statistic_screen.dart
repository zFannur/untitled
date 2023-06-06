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

  List<FilteredOperations> _sumType(
      List<Operation> operations, StatisticBloc statisticBloc) {
    List<String> filter = [];
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    List<FilteredOperations> filteredOperations = [];
    int sum = 0;

    var uniquesNames = <String, bool>{};
    for (var s in operations) {
      uniquesNames[s.form] = true;
    }
    for (var key in uniquesNames.keys) {
      filter.add(key);
    }

    for (int i = 0; i < filter.length; i++) {
      sum = 0;
      for (int j = 0; j < operations.length; j++) {
        if (filter[i] == operations[j].form &&
            statisticBloc.state.selectedDate ==
                dateFormat.parse(operations[j].date).month.toString() &&
            operations[j].type == statisticBloc.state.selectedType) {
          sum += operations[j].sum;
        }
      }
      filteredOperations.add(FilteredOperations(summa: sum, type: filter[i]));
    }
    return filteredOperations;
  }

  List<String> _getUniValuesFromList(List<Operation> operations, OperationModelFormType type) {
    List<String> filter = [];
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");
    var uniquesNames = <String, bool>{};
    for (var s in operations) {
      switch (type) {
        case OperationModelFormType.date:
          uniquesNames[dateFormat.parse(s.date).month.toString()] = true;
          break;
        case OperationModelFormType.type:
          uniquesNames[s.type] = true;
          break;
        case OperationModelFormType.form:
          uniquesNames[s.form] = true;
          break;
        case OperationModelFormType.note:
          uniquesNames[s.note] = true;
          break;
      }
    }
    for (var key in uniquesNames.keys) {
      filter.add(key);
    }
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    final statisticBloc = context.watch<StatisticBloc>();

    List<FilteredOperations> filteredOperations =
        _sumType(operationBloc.state.operations, statisticBloc);

    final List<String> month = _getUniValuesFromList(operationBloc.state.operations, OperationModelFormType.date);
    final List<String> type = _getUniValuesFromList(operationBloc.state.operations, OperationModelFormType.type);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonExample(
                list: month, type: OperationModelFormType.date),
            const SizedBox(width: 20),
            DropdownButtonExample(
                list: type, type: OperationModelFormType.type),
          ],
        ),
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
  final List<String> list;
  final OperationModelFormType type;

  const DropdownButtonExample(
      {super.key, required this.list, required this.type});

  @override
  Widget build(BuildContext context) {
    final statisticBloc = context.watch<StatisticBloc>();
    return DropdownButton<String>(
      value: type == OperationModelFormType.date
          ? statisticBloc.state.selectedDate
          : type == OperationModelFormType.type
              ? statisticBloc.state.selectedType
              : type == OperationModelFormType.form
                  ? statisticBloc.state.selectedForm
                  : type == OperationModelFormType.note
                      ? statisticBloc.state.selectedNote
                      : 'error',
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.green),
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
    );
  }
}
