import 'package:go_router/go_router.dart';

import 'package:profilaktika/db/cache.dart';
import 'package:profilaktika/pages/auth/login_screen.dart';
import 'package:profilaktika/pages/create_page/create_page.dart';
import 'package:profilaktika/pages/create_page/quiz_add.dart';
import 'package:profilaktika/pages/main_page/main_page.dart';
import 'package:profilaktika/pages/main_page/quiz_page.dart';

abstract final class Routes {
  static const loginPage = '/loginPage';
  static const mainPage = '/mainPage';
  static const themeAddPage = '/themeAddPage';
  static const quizPage = '/quizPage';
  static const quizAddPage = '/quizAddPage';
}

String _initialLocation() {
  final userToken = cache.getString("access_token");

  if (userToken != null) {
    return Routes.mainPage;
  } else {
    return Routes.loginPage;
  }
}

Object? _initialExtra() {
  return Routes.loginPage;
}

final router = GoRouter(
  initialLocation: _initialLocation(),
  initialExtra: _initialExtra(),
  routes: [
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: Routes.mainPage,
      builder: (context, state) {
        return const MainPage();
      },
    ),
    GoRoute(
      path: Routes.themeAddPage,
      builder: (context, state) {
        return const ThemeAddPage();
      },
    ),
    GoRoute(
      path: Routes.quizPage,
      builder: (context, state) {
        final lectureId = state.extra;
        return QuizPage(lectureId: lectureId);
      },
    ),
    GoRoute(
      path: Routes.quizAddPage,
      builder: (context, state) {
        final lectureId = state.extra;
        return QuizzAddPage(lectureId: lectureId);
      },
    ),
  ],
);
