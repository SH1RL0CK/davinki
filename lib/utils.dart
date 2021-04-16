import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

/*
class CourseGroup {
  final Color color;
  final List<String> courses;
  CourseGroup(this.color, this.courses);
}

Color getCourseColor(String courseTitle) {
  List<CourseGroup> courseGroups = <CourseGroup>[
    CourseGroup(Colors.blue.shade900, ['ML', 'MG']),
    CourseGroup(Colors.yellow.shade800, ['EL', 'EG']),
    CourseGroup(Colors.red, ['DL', 'DG']),
    CourseGroup(Colors.cyan, ['PRING', 'DVG', 'ERWIG']),
    CourseGroup(Colors.blueAccent, ['PRIN', 'WIL', 'METR', 'ERWI']),
    CourseGroup(Colors.teal, ['ITEC', 'RWG', 'MTTS', 'PsyG']),
    CourseGroup(Colors.purple, ['ReG', 'RkG', 'EtG']),
    CourseGroup(Colors.pink, ['PWG']),
    CourseGroup(Colors.black, ['GG']),
    CourseGroup(Colors.deepOrangeAccent, ['SpG']),
    CourseGroup(Colors.grey.shade700, ['PhG', 'BioG', 'ChG']),
    CourseGroup(Colors.lime, ['SpanG', 'FG']),
    CourseGroup(Colors.green, ['Tutor']),
  ];
  for (CourseGroup c in courseGroups) {
    for (String t in c.courses) {
      if (courseTitle.startsWith(t)) {
        return c.color;
      }
    }
  }
  return Colors.white;
}
*/

List<String> weekdayNames = <String>['Mo', 'Di', 'Mi', 'Do', 'Fr'];
