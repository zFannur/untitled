import 'package:flutter/material.dart';
import '../pages/operation_page/screens/add_operation_screen.dart';
import '../pages/operation_page/screens/edit_operation_screen.dart';
import '../router/router_screen.dart';

class RouteNames {
  static String navigationBar = '/';
  static String addOperation = '/addOperation';
  static String editOperation = '/editOperation';
}

class Navigation {
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      RouteNames.navigationBar: (context) => const RouterScreen(),
      RouteNames.addOperation: (context) => const AddOperationScreen(),
      RouteNames.editOperation: (context) => const EditOperationScreen(),
    };
  }
}
