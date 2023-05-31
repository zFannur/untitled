import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observable.dart';
import 'domain/service/hive_service.dart';
import 'internal/application.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = CharacterBlocObservable();

  HiveService hiveService = HiveService();
  await hiveService.initHive();

  await init();

  runApp(const MyApp());
}