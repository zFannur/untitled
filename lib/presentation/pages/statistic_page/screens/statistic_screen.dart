import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentation/bloc/statistic_bloc/statistic_bloc.dart';
import 'package:untitled/resource/langs/locale_keys.g.dart';

import '../../../../domain/entity/operation.dart';
import '../../../bloc/operation_bloc/operation_bloc.dart';
import '../../../widget/calc.dart';
import '../../../widget/dropdown_button_widget.dart';
import 'detail_screen.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    final statisticBloc = context.watch<StatisticBloc>();

    List<FilteredOperations> filteredOperations =
        Calc.sumType(operationBloc.state.operations, statisticBloc);

    final List<String> month = Calc.getUniValuesFromList(
        operationBloc.state.operations, OperationModelFormType.date);
    //final List<String> type = Set<String>.from(operationBloc.state.operations.map((e) => e.type.toString()).toSet()).toList();
    month.add('пусто');
    final List<String> type = Calc.getUniValuesFromList(
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
                      value: statisticBloc.state.selectedDate,
                      text: LocaleKeys.operationMonthName.tr(),
                      onChanged: (String? value) {
                        statisticBloc
                            .add(ChangeStatisticEvent(selectedDate: value!));
                      },
                    ),
                    const SizedBox(width: 20),
                    DropdownButtonWidget(
                      list: type,
                      value: statisticBloc.state.selectedType,
                      text: LocaleKeys.operationTypeName.tr(),
                      onChanged: (String? value) {
                        statisticBloc
                            .add(ChangeStatisticEvent(selectedType: value!));
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(LocaleKeys.operationSumName.tr()),
                    const SizedBox(height: 10),
                    Text(
                      Calc.getSumAll(filteredOperations),
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
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StatisticDetailListWidget(
                            filteredOperations: filteredOperations[index],
                          ),
                        ),
                      );
                    },
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
                              Text(filteredOperations[index].form),
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
