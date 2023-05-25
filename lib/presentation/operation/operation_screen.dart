import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'operation_model.dart';

class OperationScreen extends StatelessWidget {
  const OperationScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => OperationModel(),
      child: const OperationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final model = context.read<OperationModel>();
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
        if (context
            .select((OperationModel value) => value.state.operations)
            .isEmpty)
          const Center(child: CircularProgressIndicator())
        else
          const _ListOperationsWidget(),
        const ShimmerButton(),
      ],
    );
  }
}

class AddOperationButton extends StatelessWidget {
  const AddOperationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<OperationModel>();
    //final model = GetIt.instance<OperationModel>();
    return ElevatedButton(
      onPressed: () {
        model.onAddOperationButtonPressed(context, model.state.operations);
      },
      child: const SizedBox(
        height: 40.0,
        child: Center(child: Text('Add Operation')),
      ),
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
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    _colorAnimation = ColorTween(begin: Colors.red[400], end: Colors.blue[800])
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<OperationModel>();
    //final model = GetIt.instance<OperationModel>();
    _animationController.repeat();
    return MaterialButton(
      onPressed: () {
        model.onAddOperationButtonPressed(context, model.state.operations);
        setState(() {
          // _isAnimating = !_isAnimating; // Toggle the animation state
          // if (_isAnimating) {
          //    // Start the animation
          // } else {
          //   _animationController.stop(); // Stop the animation
          // }
        });
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
            child: const Text(
              'Add Operation',
              style: TextStyle(
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
    final model = context.watch<OperationModel>();
    //final model = GetIt.instance<OperationModel>();
    return model.state.internetStatus
        ? const Text('')
        : const Icon(Icons.signal_wifi_connected_no_internet_4_outlined);
  }
}

class _LeadingAppBarWidget extends StatelessWidget {
  const _LeadingAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperationModel>();
    //final model = GetIt.instance<OperationModel>();
    return model.state.isSending
        ? Row(
            children: [
              IconButton(
                onPressed: () async {
                  await model.loadOperation();
                },
                icon: const Icon(
                  Icons.file_upload,
                  size: 35,
                  color: Colors.red,
                ),
              ),
              Text(
                '${model.state.statusMessage} отправка',
                style: const TextStyle(color: Colors.red),
              )
            ],
          )
        : ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
            ),
            onPressed: model.reloadOperationInSheet,
            child: Row(
              children: const [
                Icon(
                  Icons.download,
                  size: 35,
                  color: Colors.blue,
                ),
                Text(
                  'Загрузить данные из сети',
                  style: TextStyle(color: Colors.blue),
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
    final model = context.watch<OperationModel>();
    DateFormat dateFormat = DateFormat("dd.MM.yyyy kk:mm:ss");

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: model.state.operations.length,
            itemBuilder: (context, index) {
              final operation = model.state.operations[index];
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
                      )),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [Text(operation.type), Text(operation.form)],
                    ),
                  ),
                  Expanded(child: Text(operation.sum.toString())),
                  Expanded(
                    child: IconButton(
                      // edit button
                      onPressed: () => model.onEditOperationButtonPressed(
                          context: context, index: index),
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
                        model.onDeleteButtonPressed(index, operation.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ));
            }),
      ),
    );
  }
}
