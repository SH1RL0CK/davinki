import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course.dart';
import 'package:davinki/models/course_group_templates.dart';

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
  }) : this.course = Course(courseTitle, teacher) {
    formattedDate = infoserverDateFormat(this.date);
  }

  factory Lesson.fromJson(Map<String, dynamic> lesson, {DateTime? date, int lessonNumber = -1}) {
    String teacher = '', room = '';
    String changeCaption = '', changeInformation = '';
    String newTeacher = '', newRoom = '';
    bool cancelled = false, additional = false;
    if (lesson.containsKey('teacherCodes')) {
      teacher = lesson['teacherCodes'][0];
    }
    if (lesson.containsKey('roomCodes')) {
      room = lesson['roomCodes'][0];
    }
    if (lesson.containsKey('changes')) {
      changeCaption = lesson['changes']['caption'];
      if (lesson['changes'].containsKey('information')) {
        changeInformation = lesson['changes']['information'];
      }
      if (lesson['changes'].containsKey('newTeacherCodes')) {
        newTeacher = lesson['changes']['newTeacherCodes'][0];
      }
      if (lesson['changes'].containsKey('absentTeacherCodes')) {
        teacher = lesson['changes']['absentTeacherCodes'][0];
      }
      if (lesson['changes'].containsKey('newRoomCodes')) {
        newRoom = lesson['changes']['newRoomCodes'][0];
      }
      if (lesson['changes'].containsKey('absentRoomCodes')) {
        room = lesson['changes']['absentRoomCodes'][0];
      }
      if (changeCaption == 'Klasse frei' || changeCaption == 'Klasse fehlt') {
        cancelled = true;
      }
      if (changeCaption == 'Zusatzunterricht') {
        additional = true;
      }
    }
    return Lesson(
      date ?? DateTime(-1),
      lessonNumber,
      courseTitle: lesson['courseTitle'],
      teacher: teacher,
      room: room,
      classes: lesson['classCodes'],
      changeCaption: changeCaption,
      changeInformation: changeInformation,
      newTeacher: newTeacher,
      newRoom: newRoom,
      cancelled: cancelled,
      additional: additional,
      color: getGroupTemplateByCourseTitle(lesson['courseTitle'])?.color ?? Colors.white,
    );
  }
}
