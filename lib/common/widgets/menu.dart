import 'package:flutter/material.dart';
import 'package:profilaktika/app/router.dart';
import 'package:profilaktika/common/widgets/menu_button.dart';
import 'package:profilaktika/db/cache.dart';

import '../helpers/request_helper.dart';

class UniversalMenu extends StatefulWidget {
  final Function(Widget) onMenuSelected;

  const UniversalMenu({super.key, required this.onMenuSelected});

  @override
  State<UniversalMenu> createState() => _UniversalMenuState();
}

class _UniversalMenuState extends State<UniversalMenu> {
  List<String> menu = [];
  List<String> route = [];
  List<String> icon = [];
  List<Widget> pages = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  Future<void> getMenu() async {
    try {
      final response = await requestHelper
          .getWithAuth('/api/references/get-menus', log: true);

      setState(() {
        for (var item in response) {
          menu.add(item['menu']);
          route.add(item['route']);
          icon.add(item['icon']);
          pages.add(getPageByRoute(item['route']));
        }
        print(route);
      });
    } catch (error) {
      print(error);
    }
  }

  Widget getPageByRoute(String route) {
    switch (route) {
      case 'dashboardPage':
        return Container();
      case 'nazoratVaraqasiPage':
        return Container();
      case 'bolimlarPage':
        return Container();
      case 'nazoratVaraqasiQoshishPage':
        return Container();
      default:
        return Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: theme.cardColor,
        // color: themeProvider.getColor('foreground'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 420,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return AdminMenuButton(
                  name: menu[index],
                  svgname: icon[index],
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onMenuSelected(pages[index]);
                  },
                  isSelected: isSelected,
                );
              },
            ),
          ),
          Spacer(),
          AdminMenuButton(
            name: 'Chiqish',
            svgname: 'assets/images/exit.svg',
            onPressed: () async {
              await _signOut();
            },
            isSelected: false,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      // await requestHelper.postWithAuth('/api/auth/logout', {}, log: true);
      cache.clear();
      router.go(Routes.loginPage);
    } catch (error) {
      print(error);
    }
  }
}
