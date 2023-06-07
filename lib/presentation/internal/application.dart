import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/locator_service/locator_service.dart';
import 'package:untitled/presentation/bloc/statistic_bloc/statistic_bloc.dart';
import 'package:untitled/presentation/navigation/navigation.dart';

import '../bloc/operation_bloc/operation_bloc.dart';
import '../bloc/operation_change_bloc/operation_change_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<OperationBloc>()
            ..add(GetOperationEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<OperationChangeBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<StatisticBloc>(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
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
