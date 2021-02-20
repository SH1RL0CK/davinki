import 'package:date_format/date_format.dart';

List<DateTime> getDatesOfWeek(int week) {
  List<DateTime> datesOfWeek = <DateTime>[];
  DateTime now = DateTime.now();
  DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1 - week * 7));
  if (now.weekday == 6 || now.weekday == 7) {
    firstDayOfWeek = firstDayOfWeek.add(Duration(days: 7));
  }
  for (int i = 0; i < 5; i++) {
    DateTime date = firstDayOfWeek.add(Duration(days: i));
    datesOfWeek.add(date);
  }
  return datesOfWeek;
}

String infoserverDateFormat(DateTime date) => formatDate(date, [yyyy, mm, dd]);
