import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:untitled/resource/langs/locale_keys.g.dart';

import '../../../../const/text_style.dart';
import '../../../bloc/operation_bloc/operation_bloc.dart';
import '../../../bloc/operation_change_bloc/operation_change_bloc.dart';
import '../../../navigation/navigation.dart';

class OperationScreen extends StatelessWidget {
  const OperationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _LeadingAppBarWidget(),
            _AppBarActionWidget(),
          ],
        ),
        if (operationBloc.state.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          const _ListOperationsWidget(),
        const ShimmerButton(),
      ],
    );
  }
}

class ShimmerButton extends StatefulWidget {
  const ShimmerButton({super.key});

  @override
  ShimmerButtonState createState() => ShimmerButtonState();
}

class ShimmerButtonState extends State<ShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _colorAnimation =
        ColorTween(begin: Colors.lightGreen[100], end: Colors.lightGreen)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.repeat(
      reverse: true,
    );
    return MaterialButton(
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
      textColor: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) => Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: _colorAnimation.value!.withOpacity(0.6),
                    blurRadius: 16.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      -4.0,
                      -4.0,
                    ),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _colorAnimation.value!,
                    _colorAnimation.value!.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              height: 48.0,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.operationAdd.tr(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarActionWidget extends StatelessWidget {
  const _AppBarActionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return operationBloc.state.internetConnected
        ? const Text('')
        : const Icon(Icons.signal_wifi_connected_no_internet_4_outlined);
  }
}

class _LeadingAppBarWidget extends StatelessWidget {
  const _LeadingAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final operationBloc = context.watch<OperationBloc>();
    return operationBloc.state.isSend
        ? Row(
            children: [
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
        : ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),
            onPressed: () => operationBloc.add(GetOperationEvent()),
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

            return Card(
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
                        Text(operation.type),
                        Text(operation.form),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      operation.sum.toString(),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      // edit button
                      onPressed: () {
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
                        Navigator.of(context)
                            .pushNamed(RouteNames.editOperation);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                  ),
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
            );
          },
        ),
      ),
    );
  }
}
