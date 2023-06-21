import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entity/operation.dart';
import '../../../../resource/langs/locale_keys.g.dart';
import '../../../bloc/operation_bloc/operation_bloc.dart';
import '../../../bloc/statistic_bloc/statistic_bloc.dart';
import '../../../widget/calc.dart';
import '../../../widget/dropdown_button_widget.dart';

class StatisticDetailListWidget extends StatelessWidget {
  final FilteredOperations filteredOperations;

  const StatisticDetailListWidget(
      {super.key, required this.filteredOperations});

  @override
  Widget build(BuildContext context) {
    final statisticBloc = context.watch<StatisticBloc>();
    final operationBloc = context.watch<OperationBloc>();

    List<Operation> filteredDetail = Calc.sumNote(
      operations: operationBloc.state.operations,
      statisticBloc: statisticBloc,
      form: filteredOperations.form,
    );

    final List<String> note =
        Calc.getUniValuesFromList(filteredDetail.isEmpty ? operationBloc.state.operations : filteredDetail, OperationModelFormType.note);
    note.add('пусто');

    final List<String> month =
        Calc.getUniValuesFromList(filteredDetail.isEmpty ? operationBloc.state.operations : filteredDetail, OperationModelFormType.date);
    month.add('пусто');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {

              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(filteredOperations.form),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DropdownButtonWidget(
                        list: note,
                        value: statisticBloc.state.selectedNote,
                        text: LocaleKeys.operationNoteName.tr(),
                        onChanged: (String? value) {
                          statisticBloc.add(ChangeStatisticEvent(selectedNote: value!));
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButtonWidget(
                        list: month,
                        value: statisticBloc.state.selectedDate,
                        text: LocaleKeys.operationDateName.tr(),
                        onChanged: (String? value) {
                          statisticBloc.add(ChangeStatisticEvent(selectedDate: value!));
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(LocaleKeys.operationSumName.tr()),
                      const SizedBox(height: 10),
                      Text(
                        Calc.getSumOpeartions(filteredDetail),
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDetail.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(filteredDetail[index].note),
                            Text(
                              filteredDetail[index].sum.toString(),
                            ),
                          ],
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
