import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled/resource/langs/locale_keys.g.dart';
import '../../const/text_style.dart';
import '../pages/operation_page/screens/operation_screen.dart';
import '../pages/statistic_page/screens/statistic_screen.dart';
//import 'package:restart_app/restart_app.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({Key? key}) : super(key: key);

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  int _selectedPage = 1;

  void onSelectedPage(int index) {
    if (_selectedPage == index) return;
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.routerScreenAppBarTitle.tr(),
          style: kAppBarStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (context.locale == const Locale('ru')) {
                context.setLocale(const Locale('en'));
              } else {
                context.setLocale(const Locale('ru'));
              }
              //#TODO обновитьВиджетыБезПерезагрузки
              //Restart.restartApp();
            },
            icon: const Icon(Icons.language),
          )
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: [
          const StatisticScreen(),
          const OperationScreen(), // операции
          Text(LocaleKeys.bottomBarPlan.tr()), // планирование
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.query_stats),
            label: LocaleKeys.bottomBarStatistic.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt),
            label: LocaleKeys.bottomBarOperation.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.draw),
            label: LocaleKeys.bottomBarPlan.tr(),
          ),
        ],
        onTap: onSelectedPage,
      ),
    );
  }
}
