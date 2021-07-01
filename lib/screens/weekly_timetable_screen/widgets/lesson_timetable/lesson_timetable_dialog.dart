import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_format/date_format.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_timetable/lesson_slider_item.dart';
import 'package:davinki/utils.dart';
import 'package:flutter/material.dart';

class LessonTimetableDialog extends StatefulWidget {
  final Lesson _usersLesson;
  final Map<String, dynamic> _infoserverData;
  List<dynamic> _lessonTimes = <dynamic>[], _timeslots = <dynamic>[];
  final List<Lesson> _lessons = <Lesson>[];
  bool empty = false;

  LessonTimetableDialog(this._usersLesson, this._infoserverData, {Key? key})
      : super(key: key) {
    _lessonTimes = _infoserverData['result']['displaySchedule']['lessonTimes']
        as List<dynamic>;
    _timeslots = _infoserverData['result']['timeframes'][0]['timeslots']
        as List<dynamic>;
    final DateTime date = _usersLesson.date;
    final String formattedDate = _usersLesson.formattedDate;
    final int lessonNumber = _usersLesson.lessonNumber;

    if (!_usersLesson.freeTime) {
      _lessons.add(_usersLesson);
    }

    for (final dynamic lessonAsMap in _lessonTimes) {
      if (Lesson.isLesson(lessonAsMap as Map<String, dynamic>) &&
          lessonAsMap['dates'].contains(formattedDate) as bool &&
          _timeslots.indexWhere((dynamic timeslot) =>
                  timeslot['startTime'] == lessonAsMap['startTime']) <=
              lessonNumber &&
          _timeslots.indexWhere((dynamic timeslot) =>
                  timeslot['endTime'] == lessonAsMap['endTime']) >=
              lessonNumber) {
        final int lessonIndex = _lessons.indexWhere(
            (Lesson l) => l.course.title == lessonAsMap['courseTitle']);
        final Lesson lesson = Lesson.fromJson(lessonAsMap,
            date: date, lessonNumber: lessonNumber);
        if (lessonIndex == -1 ||
            (_lessons[lessonIndex].course != lesson.course)) {
          _lessons.add(lesson);
        } else if (lesson.changeCaption.isNotEmpty &&
            _lessons[lessonIndex] != _usersLesson) {
          _lessons[lessonIndex] = lesson;
        }
      }
    }
    _lessons.sort((Lesson lesson1, Lesson lesson2) {
      return lesson1.course.compareTo(lesson2.course);
    });
    if (_lessons.isEmpty) {
      empty = true;
    }
  }

  @override
  _LessonTimetableDialogState createState() =>
      _LessonTimetableDialogState(_usersLesson, _lessons, _timeslots);
}

class _LessonTimetableDialogState extends State<LessonTimetableDialog> {
  final Lesson _usersLesson;
  final List<Lesson> _lessons;
  final List<dynamic> _timeslots;
  int _current = 0;
  _LessonTimetableDialogState(this._usersLesson, this._lessons, this._timeslots)
      : super() {
    if (!_usersLesson.freeTime) {
      _current = _lessons.indexOf(_usersLesson);
    }
  }
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      title: Text(
        '${_usersLesson.lessonNumber + 1}: ' +
            _timeslots[_usersLesson.lessonNumber]['startTime']
                .toString()
                .substring(0, 2) +
            ':' +
            _timeslots[_usersLesson.lessonNumber]['startTime']
                .toString()
                .substring(2) +
            ' - ' +
            _timeslots[_usersLesson.lessonNumber]['endTime']
                .toString()
                .substring(0, 2) +
            ':' +
            _timeslots[_usersLesson.lessonNumber]['endTime']
                .toString()
                .substring(2) +
            '  ' +
            weekdayNames[_usersLesson.date.weekday - 1] +
            ', ' +
            formatDate(_usersLesson.date, <String>[dd, '.', mm, '.', yyyy]),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      children: <Widget>[
        SizedBox(
          width: double.maxFinite,
          child: Column(children: <Widget>[
            CarouselSlider(
              items: _lessons
                  .map(
                    (Lesson lesson) => LessonSliderItem(lesson),
                  )
                  .toList(),
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 2.5,
                  enlargeCenterPage: true,
                  initialPage: !_usersLesson.freeTime
                      ? _lessons.indexOf(_usersLesson)
                      : 0,
                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _lessons.map<Container>((Lesson lesson) {
                final int index = _lessons.indexOf(lesson);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? const Color.fromRGBO(0, 0, 0, 0.9)
                        : const Color.fromRGBO(0, 0, 0, 0.4),
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
