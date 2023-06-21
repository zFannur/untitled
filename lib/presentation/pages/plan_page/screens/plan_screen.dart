import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentation/bloc/plan_bloc/plan_bloc.dart';
import '../../../../resource/langs/locale_keys.g.dart';
import '../../../widget/dropdown_button_widget.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<PlanBloc>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (operationBloc.state.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          const _PlanListWidget(),
        const SizedBox(),
        const Text('В РАЗРАБОТКЕ',
            style: TextStyle(
                fontSize: 25, color: Colors.red)),
      ],
    );
  }
}

class _PlanListWidget extends StatelessWidget {
  const _PlanListWidget();

  @override
  Widget build(BuildContext context) {
    final planBloc = context.watch<PlanBloc>();
    final List<String> month = [
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
    month.add('пусто');

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButtonWidget(
                  list: month,
                  value: '1',
                  text: LocaleKeys.operationMonthName.tr(),
                  onChanged: (String? value) {},
                ),
                const SizedBox(width: 20),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: planBloc.state.plans.length,
                itemBuilder: (context, index) {
                  return InkWell(
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
                              Expanded(
                                  child:
                                      Text(planBloc.state.plans[index].name)),
                              Expanded(
                                  child: Text(planBloc.state.plans[index].sum
                                      .toString())),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
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
