import 'package:flutter/material.dart';

class LocaleNotifier {
  static const supportedLocales = [
    Locale('en'), // Английский
    Locale('uz'), // Узбекский
    Locale('ru'), // Русский
  ];

  static const startLocale = Locale('en'); // Язык по умолчанию
}
