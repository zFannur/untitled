import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations'),
        leading: const _LeadingAppBarWidget(),
        actions: const [
          _AppBarActionWidget(),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ShimmerButton(),
          if (context
              .select((OperationModel value) => value.state.operations)
              .isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            const _ListOperationsWidget(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       model.onAddOperationButtonPressed(context, model.state.operations),
      //   child: const Icon(Icons.add),
      // ),
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
    _colorAnimation =
        ColorTween(begin: Colors.red[400], end: Colors.blue[800])
            .animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<OperationModel>();
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
            builder: (context, child) =>
                Container(
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
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0)),
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
    return model.state.isSending
        ? Row(
      children: [
        IconButton(
          onPressed: () async {
            await model.loadOperation();
          },
          icon: const Icon(Icons.file_upload),
        ),
        Text(model.state.statusMessage)
      ],
    )
        : IconButton(
      onPressed: model.reloadOperationInSheet,
      icon: const Icon(Icons.download),
    );
  }
}

class _ListOperationsWidget extends StatelessWidget {
  const _ListOperationsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<OperationModel>();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: model.state.operations.length,
            itemBuilder: (context, index) {
              final operation = model.state.operations[index];
              return Card(
                  child: Row(
                    children: [
                      SizedBox(
                          width: 65,
                          child: Center(
                            child: Text(
                                '${DateTime
                                    .parse(operation.date)
                                    .day}:${DateTime
                                    .parse(operation.date)
                                    .month}:${DateTime
                                    .parse(operation.date)
                                    .year}'),
                          )),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(operation.type),
                            Text(operation.form)
                          ],
                        ),
                      ),
                      Expanded(child: Text(operation.sum.toString())),
                      Expanded(
                        child: IconButton(
                          // edit button
                          onPressed: () =>
                              model.onEditOperationButtonPressed(
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

