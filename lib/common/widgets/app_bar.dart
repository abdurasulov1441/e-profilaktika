
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:profilaktika/common/provider/change_notifier_provider.dart';
import 'package:profilaktika/common/utils/constants.dart';
import 'package:profilaktika/db/cache.dart';

import 'package:provider/provider.dart';

class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyCustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<MyCustomAppBar> createState() => _MyCustomAppBarState();
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final name = cache.getString('first_name');
    final photo = cache.getString('photo');
    final lastName = cache.getString('last_name');

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: theme.cardColor
          //  color: themeProvider.getColor('foreground')
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Image.asset(
                'assets/images/logo.png',
                width: 34,
                height: 34,
              ),
              const SizedBox(width: 10),
              Text(
                'Nazorat varaqalar monitoringi',
                // style: themeProvider.getTextStyle().copyWith(
                //     fontSize: 26, color: themeProvider.getColor('icon')),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Hozirgi vaqt:',
                // style: themeProvider
                //     .getTextStyle()
                //     .copyWith(fontWeight: FontWeight.bold),
              ),
              DigitalClock(
                  format: "Hms",
                  showSeconds: true,
                  isLive: true,
                  // digitalClockTextColor: themeProvider.getColor('text'),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  datetime: DateTime.now()),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              child: const Text('theme')),
          Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.network(
                    '${Constants.imageUrl}$photo',
                    width: 34,
                    height: 34,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name ?? '',
                    // style: themeProvider.getTextStyle().copyWith(fontSize: 10),
                  ),
                  Text(
                    lastName ?? '',
                    // style: themeProvider.getTextStyle().copyWith(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }
}
