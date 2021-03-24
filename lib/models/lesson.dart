import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:davinki/utils.dart';

class Lesson {
  final String course, teacher, room;
  final DateTime date;
  String formattedDate;
  final int lessonNumber;
  final String changeCaption, changeInformation;
  final String newTeacher, newRoom;
  final bool cancelled, additional, freeTime;
  final Color color;
  bool currentLesson;

  Lesson(
    this.date,
    this.lessonNumber, {
    this.course = '',
    this.teacher = '',
    this.room = '',
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
  }) {
    formattedDate = infoserverDateFormat(this.date);
  }

  factory Lesson.fromJson(Map<String, dynamic> lesson, DateTime date, int lessonNumber) {
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
      date,
      lessonNumber,
      course: lesson['courseTitle'],
      teacher: teacher,
      changeCaption: changeCaption,
      changeInformation: changeInformation,
      room: room,
      newTeacher: newTeacher,
      newRoom: newRoom,
      cancelled: cancelled,
      additional: additional,
      color: getCourseColor(lesson['courseTitle']),
    );
  }
}
