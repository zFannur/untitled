import 'package:flutter/material.dart';
import 'package:untitled/presentation/edit_operation/edit_operation_screen.dart';
import 'package:untitled/presentation/operation/operation_screen.dart';

import '../presentation/add_operation/add_operation_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => OperationScreen.create(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/addOperation': (context) => AddOperationScreen.create(),
        '/editOperation': (context) => EditOperationScreen.create(),
      },
    );
  }
}
