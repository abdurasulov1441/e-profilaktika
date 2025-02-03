import 'package:flutter/material.dart';
import 'package:profilaktika/app/theme.dart';
import 'package:provider/provider.dart';
import '../common/provider/change_notifier_provider.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkTheme;
    return MaterialApp.router(
      title: 'Nazorat Varaqasi',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: router,
    );
  }
}
