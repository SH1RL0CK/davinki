import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_format/date_format.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_timetable/lesson_slider_item.dart';
import 'package:davinki/utils.dart';

class LessonTimetableDialog extends StatefulWidget {
  final Lesson _usersLesson;
  final Map<String, dynamic> _infoserverData;
  List _lessonTimes = [], _timeslots = [];
  List<Lesson> _lessons = <Lesson>[];
  bool empty = false;

  LessonTimetableDialog(this._usersLesson, this._infoserverData, {Key? key}) : super(key: key) {
    this._lessonTimes = this._infoserverData['result']['displaySchedule']['lessonTimes'];
    this._timeslots = this._infoserverData['result']['timeframes'][0]['timeslots'];
    DateTime date = this._usersLesson.date;
    String formattedDate = this._usersLesson.formattedDate;
    int lessonNumber = this._usersLesson.lessonNumber;

    if (!this._usersLesson.freeTime) {
      this._lessons.add(this._usersLesson);
    }

    this._lessonTimes.forEach((lessonAsMap) {
      if (lessonAsMap.containsKey('dates') &&
          lessonAsMap['dates'].contains(formattedDate) &&
          lessonAsMap.containsKey('startTime') &&
          lessonAsMap.containsKey('endTime') &&
          this._timeslots.indexWhere((timeslot) => timeslot['startTime'] == lessonAsMap['startTime']) <= lessonNumber &&
          this._timeslots.indexWhere((timeslot) => timeslot['endTime'] == lessonAsMap['endTime']) >= lessonNumber) {
        int lessonIndex = this._lessons.indexWhere((l) => l.course.title == lessonAsMap['courseTitle']);
        Lesson lesson = Lesson.fromJson(lessonAsMap, date: date, lessonNumber: lessonNumber);
        if (lessonIndex == -1 || (this._lessons[lessonIndex].course != lesson.course)) {
          this._lessons.add(lesson);
        } else if (lesson.changeCaption.isNotEmpty && this._lessons[lessonIndex] != this._usersLesson) {
          this._lessons[lessonIndex] = lesson;
        }
      }
    });
    this._lessons.sort((lesson1, lesson2) {
      return lesson1.course.compareTo(lesson2.course);
    });
    if (this._lessons.length == 0) {
      this.empty = true;
    }
  }

  @override
  _LessonTimetableDialogState createState() => _LessonTimetableDialogState(this._usersLesson, this._lessons, this._timeslots);
}

class _LessonTimetableDialogState extends State<LessonTimetableDialog> {
  final Lesson _usersLesson;
  final List<Lesson> _lessons;
  final List _timeslots;
  int _current = 0;
  _LessonTimetableDialogState(this._usersLesson, this._lessons, this._timeslots) : super() {
    if (!this._usersLesson.freeTime) {
      this._current = this._lessons.indexOf(this._usersLesson);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      title: Text(//formatDate(this._usersLesson.date, [dd, '.', mm, '.', yyyy]) +
          '${this._usersLesson.lessonNumber + 1}: ' +
              this._timeslots[this._usersLesson.lessonNumber]['startTime'].substring(0, 2) +
              ':' +
              this._timeslots[this._usersLesson.lessonNumber]['startTime'].substring(2) +
              ' - ' +
              this._timeslots[this._usersLesson.lessonNumber]['endTime'].substring(0, 2) +
              ':' +
              this._timeslots[this._usersLesson.lessonNumber]['endTime'].substring(2) +
              '  ' +
              weekdayNames[this._usersLesson.date.weekday - 1] +
              ', ' +
              formatDate(this._usersLesson.date, [dd, '.', mm, '.', yyyy])),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
      children: <Widget>[
        Container(
          height: 230,
          width: double.maxFinite,
          child: Column(children: [
            CarouselSlider(
              items: this
                  ._lessons
                  .map(
                    (lesson) => LessonSliderItem(lesson),
                  )
                  .toList(),
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  initialPage: !this._usersLesson.freeTime ? this._lessons.indexOf(this._usersLesson) : 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: this._lessons.map((lesson) {
                int index = this._lessons.indexOf(lesson);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Color.fromRGBO(0, 0, 0, 0.9) : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]),
        ),
      ],
    );
  }
}
