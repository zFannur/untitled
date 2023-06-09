import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/internal/application.dart';
import 'package:untitled/resource/langs/codegen_loader.g.dart';
import 'locator_service/locator_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await init();

  runApp(
    EasyLocalization(
      // для генерации парсера flutter pub run easy_localization:generate -S "lib/resource/langs" -O "lib/resource/langs"
      // для генерации ключей flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart -S "lib/resource/langs" -O "lib/resource/langs"
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'lib/resource/lang',
      fallbackLocale: const Locale('ru'),
      assetLoader: const CodegenLoader(),
      child: MyApp(savedThemeMode: savedThemeMode),
    ),
  );
}
