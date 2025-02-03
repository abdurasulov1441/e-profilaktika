import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class AdminStatistic extends StatelessWidget {
  const AdminStatistic({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: 130,
      decoration: BoxDecoration(
          // color: themeProvider.getColor('background'),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatisticsWidgetNew(
            svgname: 'assets/images/nazorat_varaqasi.svg',
            text: 'Nazorat varaqasi',
            number: '127',
          ),
          StatisticsWidgetNew(
            svgname: 'assets/images/new.svg',
            text: 'Yangi',
            number: '127',
          ),
          StatisticsWidgetNew(
            svgname: 'assets/images/acepted.svg',
            text: 'Qabul qilingan',
            number: '25',
          ),
          StatisticsWidgetNew(
            svgname: 'assets/images/completed.svg',
            text: 'Bajarilgan',
            number: '33',
          ),
        ],
      ),
    );
  }
}

class StatisticsWidgetNew extends StatelessWidget {
  const StatisticsWidgetNew(
      {super.key,
      required this.svgname,
      required this.text,
      required this.number});

  final String svgname;
  final String text;
  final String number;

  @override
  Widget build(BuildContext context) {
   
    return Flexible(
      child: Container(
        height: 130,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: themeProvider.getColor('foreground')
            ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              svgname,
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                ),
                Text('$number ta',
                    style: TextStyle(
                      fontSize: 20,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
