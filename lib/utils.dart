import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

List<String> weekdayNames = <String>['Mo', 'Di', 'Mi', 'Do', 'Fr'];

List<DateTime> getDatesOfWeek(int week) {
  final List<DateTime> datesOfWeek = <DateTime>[];
  final DateTime now = DateTime.now();
  DateTime firstDayOfWeek =
      now.subtract(Duration(days: now.weekday - 1 - week * 7));
  if (<int>[6, 7].contains(now.weekday)) {
    firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
  }
  for (int i = 0; i < 5; i++) {
    final DateTime date = firstDayOfWeek.add(Duration(days: i));
    datesOfWeek.add(date);
  }
  return datesOfWeek;
}

String infoserverDateFormat(DateTime date) =>
    formatDate(date, <String>[yyyy, mm, dd]);

void navigateToOtherScreen(Widget screen, BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute<dynamic>(builder: (BuildContext context) => screen),
    (Route<dynamic> route) => false,
  );
}
