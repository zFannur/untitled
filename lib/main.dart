import 'package:flutter/material.dart';
import 'internal/application.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}