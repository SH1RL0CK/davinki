import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_format/date_format.dart';
import 'package:davinki/constants.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_timetable/lesson_slider_item.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LessonTimetableDialog extends StatefulWidget {
  final Lesson _usersLesson;
  final Map<String, dynamic> _infoserverData;
  List<dynamic> _lessonTimes = <dynamic>[];
  List<dynamic> _timeslots = <dynamic>[];
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
          _timeslots.indexWhere(
                (dynamic timeslot) =>
                    timeslot['startTime'] == lessonAsMap['startTime'],
              ) <=
              lessonNumber &&
          _timeslots.indexWhere(
                (dynamic timeslot) =>
                    timeslot['endTime'] == lessonAsMap['endTime'],
              ) >=
              lessonNumber) {
        final int lessonIndex = _lessons.indexWhere(
          (Lesson l) => l.course.title == lessonAsMap['courseTitle'],
        );
        final Lesson lesson = Lesson.fromJson(
          lessonAsMap,
          date: date,
          lessonNumber: lessonNumber,
        );
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
  CarouselController lessonCarouselController = CarouselController();
  _LessonTimetableDialogState(this._usersLesson, this._lessons, this._timeslots)
      : super() {
    if (!_usersLesson.freeTime) {
      _current = _lessons.indexOf(_usersLesson);
    }
  }
  @override
  Widget build(BuildContext context) {
    final int lessonNumber = _usersLesson.lessonNumber + 1;
    final String startTime =
        _timeslots[_usersLesson.lessonNumber]['startTime'].toString();
    final String formattedStartTime =
        '${startTime.substring(0, 2)}:${startTime.substring(2)}';
    final String endTime =
        _timeslots[_usersLesson.lessonNumber]['endTime'].toString();
    final String formattedEndTime =
        '${endTime.substring(0, 2)}:${endTime.substring(2)}';
    final String weekdayName = kWeekdayNames[_usersLesson.date.weekday - 1];
    final String formattedDate =
        formatDate(_usersLesson.date, <String>[dd, '.', mm, '.', yyyy]);

    return SimpleDialog(
      titleTextStyle: const TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      title: Text(
        '$lessonNumber: $formattedStartTime - $formattedEndTime  $weekdayName, $formattedDate',
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width >= kDesktopBreakpoint
              ? 600.0
              : double.maxFinite,
          child: Column(
            children: <Widget>[
              CarouselSlider(
                items: _lessons
                    .map(
                      (Lesson lesson) => LessonSliderItem(lesson),
                    )
                    .toList(),
                carouselController: lessonCarouselController,
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
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                      InkWell(
                        onTap: () => lessonCarouselController.previousPage(),
                        child: const Icon(Icons.keyboard_arrow_left),
                      )
                    ] +
                    _lessons.map<Widget>((Lesson lesson) {
                      final int index = _lessons.indexOf(lesson);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 2.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? const Color.fromRGBO(0, 0, 0, 0.9)
                              : const Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                        child: InkWell(
                          onTap: () =>
                              lessonCarouselController.animateToPage(index),
                        ),
                      );
                    }).toList() +
                    <Widget>[
                      InkWell(
                        onTap: () => lessonCarouselController.nextPage(),
                        child: const Icon(Icons.keyboard_arrow_right),
                      )
                    ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
