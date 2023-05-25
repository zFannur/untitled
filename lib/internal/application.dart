import 'package:flutter/material.dart';
import 'package:untitled/presentation/navigation/navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
        useMaterial3: true,
      ),
      initialRoute: RouteNames.navigationBar,
      routes: Navigation.routes,
    );
  }
}
