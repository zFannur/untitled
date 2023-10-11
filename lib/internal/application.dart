import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/const/app_theme.dart';
import 'package:untitled/locator_service/locator_service.dart';
import 'package:untitled/presentation/bloc/plan_bloc/plan_bloc.dart';
import 'package:untitled/presentation/bloc/statistic_bloc/statistic_bloc.dart';
import 'package:untitled/presentation/navigation/navigation.dart';
import 'package:untitled/presentation/bloc/operation_bloc/operation_bloc.dart';
import 'package:untitled/presentation/bloc/operation_change_bloc/operation_change_bloc.dart';


class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({Key? key, required this.savedThemeMode}) : super(key: key);

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
        BlocProvider(
          create: (context) => getIt<PlanBloc>()
            ..add(GetPlanEvent()),
        ),
      ],
      child: AdaptiveTheme(
        light: AppTheme.lightTheme,
        dark: AppTheme.darkTheme,
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: RouteNames.navigationBar,
          routes: Navigation.routes,
        ),
      ),
    );
  }
}
