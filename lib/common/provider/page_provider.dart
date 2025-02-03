
// import 'package:flutter/material.dart';

// class PageProvider with ChangeNotifier {

//     Widget _currentPage = const MainPageElements();


//   Widget get currentPage => _currentPage;
//   void updatePage(Widget page) {
//     _currentPage = page;
//     notifyListeners();
//   }

//   void updatePageByRoute(String route) {
//     Widget page;
//     switch (route) {
//       case 'dashboardPage':
//         page = const MainPageElements();
//         break;
//       case 'nazoratVaraqasiPage':
//         page = const NazoratVaraqalari();
//         break;
//       case 'bolimlarPage':
//         page = const Calendar();
//         break;
//       case 'nazoratVaraqasiQoshishPage':
//         page = const NazoratVaraqasiQoshish();
//         break;
//       default:
//         page = const Placeholder();
//     }
//     _currentPage = page;
//     notifyListeners();
//   }
// }
