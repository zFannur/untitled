import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/presentation/navigation/navigation.dart';

import '../domain/service/api_service.dart';
import '../domain/service/hive_service.dart';
import '../presentation/operation_page/operation_bloc/operation_bloc.dart';
import '../presentation/operation_page/operation_change_bloc/operation_change_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApiService apiService = ApiService();
    HiveService hiveService = HiveService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OperationBloc(
              apiService: apiService, hiveService: hiveService)
            ..add(GetOperationEvent()),
        ),
        BlocProvider(
          create: (context) => OperationChangeBloc(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        initialRoute: RouteNames.navigationBar,
        routes: Navigation.routes,
      ),
    );
  }
}
