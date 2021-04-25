import 'package:flutter/material.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/date_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/timseslot_cell.dart';

class WeeklyTimetable extends StatefulWidget {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  final CourseSettings _courseSettings;
  WeeklyTimetable(this._week, this._infoserverData, this._courseSettings, {Key? key}) : super(key: key);

  @override
  _WeeklyTimetableState createState() => _WeeklyTimetableState(this._week, this._infoserverData, this._courseSettings);
}

class _WeeklyTimetableState extends State<WeeklyTimetable> {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  final CourseSettings _courseSettings;
  _WeeklyTimetableState(this._week, this._infoserverData, this._courseSettings) : super();
  List<List<Lesson>> _getLessons(List lessonTimes, List timeslots, List<DateTime> datesOfWeek) {
    List<List<Lesson>> lessons = <List<Lesson>>[];

    List<String> formatedDatesOfWeek = <String>[];

    datesOfWeek.forEach((DateTime date) => formatedDatesOfWeek.add(infoserverDateFormat(date)));

    for (int i = 0; i < timeslots.length; i++) {
      List<Lesson> l = <Lesson>[];
      for (int j = 0; j < 5; j++) {
        l.add(Lesson(datesOfWeek[j], i, freeTime: true));
      }
      lessons.add(l);
    }

    for (Map<String, dynamic> lessonAsMap in lessonTimes) {
      if (!Lesson.isLesson(lessonAsMap)) {
        continue;
      }
      Lesson lesson = Lesson.fromJson(lessonAsMap);
      bool isUsersLesson = this._courseSettings.usersCourses.contains(lesson.course);
      if (isUsersLesson) {
        formatedDatesOfWeek.asMap().forEach(
          (int weekdayIndex, String date) {
            if (lessonAsMap.containsKey('dates') && lessonAsMap['dates'].contains(date)) {
              int lessonNumber = 0;
              timeslots.asMap().forEach((timeslotIndex, timeslot) {
                if (timeslot['startTime'] == lessonAsMap['startTime']) {
                  lessonNumber = timeslotIndex;
                }
              });
              for (; lessonNumber < timeslots.length; lessonNumber++) {
                if (lesson.changeCaption.isNotEmpty || lessons[lessonNumber][weekdayIndex].freeTime) {
                  lesson.date = datesOfWeek[weekdayIndex];
                  lesson.formattedDate = infoserverDateFormat(lesson.date);
                  lesson.lessonNumber = lessonNumber;
                  lessons[lessonNumber][weekdayIndex] = lesson;
                }
                if (lessonAsMap['endTime'] == timeslots[lessonNumber]['endTime']) {
                  break;
                }
              }
            }
          },
        );
      }
    }
    return lessons;
  }

  List<TableRow> _buildTimetable() {
    List<DateTime> datesOfWeek = getDatesOfWeek(this._week);
    List lessonTimes = this._infoserverData['result']['displaySchedule']['lessonTimes'];
    List timeslots = this._infoserverData['result']['timeframes'][0]['timeslots'];

    List<List<Lesson>> lessons = _getLessons(lessonTimes, timeslots, datesOfWeek);

    List<TableCell> firstRow = <TableCell>[TableCell(child: Container())];

    datesOfWeek.forEach((DateTime date) {
      firstRow.add(TableCell(child: DateCell(date)));
    });

    List<TableRow> rows = <TableRow>[
      TableRow(children: firstRow, decoration: BoxDecoration(color: Colors.white)),
    ];

    for (int i = 0; i < lessons.length; i++) {
      List<TableCell> cells = <TableCell>[
        TableCell(child: TimeslotCell(timeslots[i])),
      ];
      for (int j = 0; j < 5; j++) {
        cells.add(
          TableCell(
            child: LessonCell(lessons[i][j], this._infoserverData),
          ),
        );
      }
      rows.add(TableRow(
        children: cells,
        decoration: BoxDecoration(
          color: (i % 2 == 0) ? Colors.pink[50] : Colors.white,
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: this._buildTimetable(),
            columnWidths: {
              0: FixedColumnWidth(58),
            },
          ),
        ),
      ),
    );
  }
}
