import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentation/bloc/plan_bloc/plan_bloc.dart';

import '../../const/text_style.dart';
import '../../resource/langs/locale_keys.g.dart';
import '../bloc/operation_bloc/operation_bloc.dart';

class AppBarSendStatus extends StatelessWidget {
  const AppBarSendStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    final planBloc = context.watch<PlanBloc>();
    return operationBloc.state.isSend
        ? Row(
            children: [
              operationBloc.state.internetConnected
                  ? const Text('')
                  : const Icon(
                      Icons.signal_wifi_connected_no_internet_4_outlined),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_upload,
                  size: 35,
                  color: Colors.red,
                ),
              ),
              Text(
                '${LocaleKeys.operationToSend.tr()}${operationBloc.state.cacheLength}',
                style: kRedTextStyle,
              )
            ],
          )
        : TextButton(
            onPressed: () {
              operationBloc.add(GetOperationEvent());
              planBloc.add(GetPlanEvent());
            },
            child: Row(
              children: [
                const Icon(
                  Icons.download,
                  size: 35,
                  color: Colors.blue,
                ),
                Text(
                  operationBloc.state.cacheLength == 0
                      ? LocaleKeys.operationFromTable.tr()
                      : '${LocaleKeys.operationFromTable.tr()}${LocaleKeys.operationToSend.tr()} ${operationBloc.state.cacheLength}',
                  style: kBlueTextStyle,
                )
              ],
            ),
          );
  }
}
