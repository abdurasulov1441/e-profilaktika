import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/date_symbol_data_local.dart'; // ← Kiritish kerak
import 'package:profilaktika/app/app.dart';
import 'package:profilaktika/common/locale/notifiers/locale_notifier.dart';
import 'package:profilaktika/common/provider/change_notifier_provider.dart';
import 'package:profilaktika/db/cache.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EasyLocalization.logger.enableLevels = [];
  await EasyLocalization.ensureInitialized();
  await initializeCache();

  await initializeDateFormatting('uz_UZ', null); // ← Qo'shish kerak

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: LocaleNotifier.supportedLocales,
      startLocale: LocaleNotifier.startLocale,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(cache)),
        ],
        child: const App(),
      ),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1366, 768);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "E-Profilaktika";
    appWindow.show();
  });
}
