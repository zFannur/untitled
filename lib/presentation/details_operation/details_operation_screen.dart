import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detail_operation_model.dart';

class DetailOperationScreen extends StatelessWidget {
  const DetailOperationScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => DetailOperationModel(),
      child: const DetailOperationScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
