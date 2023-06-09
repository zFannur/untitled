import 'package:adaptive_theme/adaptive_theme.dart';
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

  void toggleThemeMode() {
    if (AdaptiveTheme.of(context).theme ==
        AdaptiveTheme.of(context).darkTheme) {
      AdaptiveTheme.of(context).setLight();
    } else {
      AdaptiveTheme.of(context).setDark();
    }
    //AdaptiveTheme.of(context).toggleThemeMode();
  }

  @override
  Widget build(BuildContext context) {
    //final List<bool> _selectedWeather = <bool>[false, true];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.routerScreenAppBarTitle.tr(),
          style: kAppBarStyle,
        ),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    const Icon(Icons.language),
                    context.locale == const Locale('ru')
                        ? const Text(' - RU')
                        : const Text(' - EN'),
                  ],
                ),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('ToggleTheme'),
                // ToggleButtons(
                //   onPressed: (int index) {
                //     if (index == 0) {
                //       _selectedWeather[0] = 0 == index;
                //       AdaptiveTheme.of(context).setLight();
                //     } else if (index == 1) {
                //       _selectedWeather[1] = 1 == index;
                //       AdaptiveTheme.of(context).setDark();
                //     }
                //   },
                //   borderRadius: const BorderRadius.all(Radius.circular(8)),
                //   selectedBorderColor: Colors.green[700],
                //   selectedColor: Colors.white,
                //   fillColor: Colors.green[200],
                //   color: Colors.green[400],
                //   constraints: const BoxConstraints(
                //     minHeight: 40.0,
                //     minWidth: 80.0,
                //   ),
                //   isSelected: _selectedWeather,
                //   children: const [
                //     Icon(Icons.light_mode_outlined),
                //     Icon(Icons.light_mode),
                //   ],
                // ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 0) {
              if (context.locale == const Locale('ru')) {
                await context.setLocale(const Locale('en'));
              } else {
                await context.setLocale(const Locale('ru'));
              }
              //#TODO обновитьВиджетыБезПерезагрузки
              //Restart.restartApp();
            } else if (value == 1) {
              toggleThemeMode();
            } else if (value == 2) {
              print("Logout menu is selected.");
            }
          }),
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
