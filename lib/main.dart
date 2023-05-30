import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'bloc_observable.dart';
import 'domain/service/hive_service.dart';
import 'internal/application.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  HydratedBloc.storage = storage;
  Bloc.observer = CharacterBlocObservable();

  HiveService hiveService = HiveService();
  await hiveService.initHive();

  await init();

  runApp(const MyApp());
}