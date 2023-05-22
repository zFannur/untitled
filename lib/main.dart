import 'package:flutter/material.dart';
import 'domain/service/hive_service.dart';
import 'internal/application.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HiveService hiveService = HiveService();
  await hiveService.initHive();

  await init();

  runApp(const MyApp());
}