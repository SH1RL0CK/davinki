import 'package:davinki/models/course.dart';
import 'package:davinki/models/subject_templates.dart';
import 'package:davinki/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lesson {
  final Course course;
  final String room;
  final List<dynamic> classes;
  DateTime date;
  String formattedDate;
  int lessonNumber;
  final String changeCaption, changeInformation;
  final String newTeacher, newRoom;
  final bool cancelled, additional, freeTime;
  final Color color;
  bool currentLesson;

  Lesson(
    this.date,
    this.lessonNumber, {
    String courseTitle = '',
    String teacher = '',
    this.room = '',
    this.classes = const <dynamic>[],
    this.formattedDate = '',
    this.changeCaption = '',
    this.changeInformation = '',
    this.newTeacher = '',
    this.newRoom = '',
    this.freeTime = false,
    this.cancelled = false,
    this.additional = false,
    this.color = Colors.transparent,
    this.currentLesson = false,
  }) : course = Course(courseTitle, teacher) {
    formattedDate = infoserverDateFormat(date);
  }

  static bool isLesson(Map<String, dynamic> map) {
    for (final String key in <String>[
      'courseTitle',
      'startTime',
      'endTime',
      'dates'
    ]) {
      if (!map.containsKey(key)) return false;
    }
    return true;
  }

  factory Lesson.fromJson(Map<String, dynamic> lesson,
      {DateTime? date, int lessonNumber = -1}) {
    String teacher = '', room = '';
    String changeCaption = '', changeInformation = '';
    String newTeacher = '', newRoom = '';
    bool cancelled = false, additional = false;
    if (lesson.containsKey('teacherCodes')) {
      teacher = lesson['teacherCodes'][0].toString();
    }
    if (lesson.containsKey('roomCodes')) {
      room = lesson['roomCodes'][0].toString();
    }
    if (lesson.containsKey('changes')) {
      changeCaption = lesson['changes']['caption'].toString();
      if (lesson['changes'].containsKey('information') as bool) {
        changeInformation = lesson['changes']['information'].toString();
      }
      if (lesson['changes'].containsKey('newTeacherCodes') as bool) {
        newTeacher = lesson['changes']['newTeacherCodes'][0].toString();
      }
      if (lesson['changes'].containsKey('absentTeacherCodes') as bool) {
        teacher = lesson['changes']['absentTeacherCodes'][0].toString();
      }
      if (lesson['changes'].containsKey('newRoomCodes') as bool) {
        newRoom = lesson['changes']['newRoomCodes'][0].toString();
      }
      if (lesson['changes'].containsKey('absentRoomCodes') as bool) {
        room = lesson['changes']['absentRoomCodes'][0].toString();
      }
      if (<String>['Klasse frei', 'Klasse fehlt'].contains(changeCaption)) {
        cancelled = true;
      }
      if (changeCaption == 'Zusatzunterricht') {
        additional = true;
      }
    }
    return Lesson(
      date ?? DateTime(-1),
      lessonNumber,
      courseTitle: lesson['courseTitle'].toString(),
      teacher: teacher,
      room: room,
      classes: lesson['classCodes'] as List<dynamic>,
      changeCaption: changeCaption,
      changeInformation: changeInformation,
      newTeacher: newTeacher,
      newRoom: newRoom,
      cancelled: cancelled,
      additional: additional,
      color: getSubjectTemplateByCourseTitle(lesson['courseTitle'].toString())
              ?.color ??
          Colors.pink,
    );
  }
}
