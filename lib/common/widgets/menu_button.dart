
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../provider/change_notifier_provider.dart';

class AdminMenuButton extends StatelessWidget {
  const AdminMenuButton({
    super.key,
    required this.name,
    required this.svgname,
    required this.onPressed,
    required this.isSelected,
  });

  final String name;
  final String svgname;
  final VoidCallback onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 5),
          // backgroundColor: themeProvider.getColor('foreground'),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  themeProvider.isDarkTheme ? Color(0xFF175F8C) : Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
            ),
            SvgPicture.asset(
              svgname,
              width: 22,
              height: 22,
              // color: isSelected
              //     ? themeProvider.getColor('icon')
              //     : themeProvider.getColor('divider'),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              name,
              // style: themeProvider.getTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
