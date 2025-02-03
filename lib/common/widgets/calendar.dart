import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';



class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 10, left: 15),
      decoration: BoxDecoration(
          // color: themeProvider.getColor('foreground'),
          borderRadius: BorderRadius.circular(10)),
      child: AdminDashboardCalendar(),
    );
  }
}

class AdminDashboardCalendar extends StatefulWidget {
  const AdminDashboardCalendar({super.key});

  @override
  State<AdminDashboardCalendar> createState() => _AdminDashboardCalendarState();
}

class _AdminDashboardCalendarState extends State<AdminDashboardCalendar> {
  @override
  Widget build(BuildContext context) {

    return Expanded(
      flex: 1,
      child: Container(
          padding: EdgeInsets.all(15),
          height: 300,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              // color: themeProvider.getColor('foreground'),
              borderRadius: BorderRadius.circular(10)),
          child: SimpleCalendarPage()),
    );
  }
}

class SimpleCalendarPage extends StatelessWidget {
  const SimpleCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<DateTime?> selectedDate = [DateTime.now()];

    return Center(
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: Colors.orange,
          firstDayOfWeek: 1,
        ),
        value: selectedDate,
        onValueChanged: (dates) {
          print('Выбрана дата: ${dates.first}');
        },
      ),
    );
  }
}
