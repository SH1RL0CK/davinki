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

String infoserverDateFormat(DateTime? date) => formatDate(date!, [yyyy, mm, dd]);

class CourseColor {
  final Color color;
  final List<String> courses;
  CourseColor(this.color, this.courses);
}

Color getCourseColor(String courseTitle) {
  List<CourseColor> courseColors = <CourseColor>[
    CourseColor(Colors.blue.shade900, ['ML', 'MG']),
    CourseColor(Colors.yellow.shade800, ['EL', 'EG']),
    CourseColor(Colors.redAccent, ['DL', 'DG']),
    CourseColor(Colors.cyan.shade600, ['PRING', 'DVG', 'ERWIG']),
    CourseColor(Colors.blueAccent, ['PRIN', 'WIL', 'METR', 'ERWI']),
    CourseColor(Colors.teal, ['ITEC', 'RWG', 'MTTS', 'PsyG']),
    CourseColor(Colors.pink, ['ReG', 'RkG', 'EtG']),
    CourseColor(Colors.pinkAccent, ['PWG']),
    CourseColor(Colors.black, ['GG']),
    CourseColor(Colors.deepOrangeAccent, ['SpG']),
    CourseColor(Colors.blueGrey, ['PhG', 'BioG', 'ChG']),
    CourseColor(Colors.green, ['Tutor']),
  ];
  for (CourseColor c in courseColors) {
    for (String t in c.courses) {
      if (courseTitle.startsWith(t)) {
        return c.color;
      }
    }
  }
  return Colors.white;
}

List<String> weekdayNames = <String>['Mo', 'Di', 'Mi', 'Do', 'Fr'];
