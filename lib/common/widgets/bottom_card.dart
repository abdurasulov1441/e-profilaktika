import 'package:flutter/material.dart';


class BottomCard extends StatelessWidget {
  const BottomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 10,
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
              // color: themeProvider.getColor('foreground'),
              borderRadius: BorderRadius.circular(10)),
        ));
  }
}
