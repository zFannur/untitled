import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/domain/use_case/api_use_case.dart';
import 'package:untitled/domain/use_case/hive_use_case.dart';
import 'bloc_observable.dart';
import 'internal/application.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = CharacterBlocObservable();

  HiveUseCase hiveService = HiveUseCaseImpl();
  await hiveService.initHive();

  await init();

  runApp(const MyApp());
}