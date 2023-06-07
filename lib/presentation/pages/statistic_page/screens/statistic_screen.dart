import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentation/bloc/statistic_bloc/statistic_bloc.dart';
import 'package:untitled/resource/langs/locale_keys.g.dart';

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
          const _StatisticListWidget(),
        const SizedBox(),
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
        if (statisticBloc.state.selectedDate == 'пусто') {
          if (filter[i] == operations[j].form &&
              operations[j].type == statisticBloc.state.selectedType) {
            sum += operations[j].sum;
          }
        } else {
          if (filter[i] == operations[j].form &&
              statisticBloc.state.selectedDate ==
                  dateFormat.parse(operations[j].date).month.toString() &&
              operations[j].type == statisticBloc.state.selectedType) {
            sum += operations[j].sum;
          }
        }
      }
      filteredOperations.add(FilteredOperations(summa: sum, type: filter[i]));
    }
    return filteredOperations;
  }

  String _getSumAll(List<FilteredOperations> filteredOperations) {
    int sum = 0;
    for (int i = 0; i < filteredOperations.length; i++) {
      sum += filteredOperations[i].summa;
    }

    return sum.toString();
  }

  List<String> _getUniValuesFromList(
      List<Operation> operations, OperationModelFormType type) {
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

    final List<String> month = _getUniValuesFromList(
        operationBloc.state.operations, OperationModelFormType.date);
    month.add('пусто');
    final List<String> type = _getUniValuesFromList(
        operationBloc.state.operations, OperationModelFormType.type);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DropdownButtonWidget(
                      list: month,
                      type: OperationModelFormType.date,
                      text: LocaleKeys.operationMonthName.tr(),
                    ),
                    const SizedBox(width: 20),
                    DropdownButtonWidget(
                      list: type,
                      type: OperationModelFormType.type,
                      text: LocaleKeys.operationTypeName.tr(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(LocaleKeys.operationSumName.tr()),
                    const SizedBox(height: 10),
                    Text(
                      _getSumAll(filteredOperations),
                      style: const TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOperations.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    splashColor: Colors.green.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    onTap: () {},
                    child: Card(
                      child: SizedBox(
                        //color: index % 2 == 0 ? Colors.white : Colors.green[100],
                        //padding: const EdgeInsets.all(5),
                        height: MediaQuery.of(context).size.height / 15,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(filteredOperations[index].type),
                              Text(
                                filteredOperations[index].summa.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
