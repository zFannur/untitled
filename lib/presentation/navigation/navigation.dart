import 'package:flutter/material.dart';

import '../add_operation/add_operation_screen.dart';
import '../edit_operation/edit_operation_screen.dart';
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
      RouteNames.addOperation: (context) => AddOperationScreen.create(),
      RouteNames.editOperation: (context) => EditOperationScreen.create(),
    };
  }
}
