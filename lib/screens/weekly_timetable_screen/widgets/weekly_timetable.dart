import 'package:flutter/material.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/secret.dart' as secret;
import 'package:davinki/models/lesson.dart';
import 'package:davinki/models/subject.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/date_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/timseslot_cell.dart';

class WeeklyTimetable extends StatefulWidget {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  WeeklyTimetable(this._week, this._infoserverData, {Key? key}) : super(key: key);

  @override
  _WeeklyTimetableState createState() => _WeeklyTimetableState(this._week, this._infoserverData);
}

class _WeeklyTimetableState extends State<WeeklyTimetable> {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  _WeeklyTimetableState(this._week, this._infoserverData) : super();
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

    for (Map<String, dynamic> lesson in lessonTimes) {
      bool isUsersLesson = false;
      secret.mySubjects.forEach((Subject subject) {
        if (subject.name == lesson['courseTitle'] && subject.teacher == lesson['teacherCodes'][0]) {
          isUsersLesson = true;
        }
      });
      if (isUsersLesson) {
        formatedDatesOfWeek.asMap().forEach(
          (int weekdayIndex, String date) {
            if (lesson.containsKey('dates') && lesson['dates'].contains(date)) {
              int lessonNumber = 0;
              timeslots.asMap().forEach((timeslotIndex, timeslot) {
                if (timeslot['startTime'] == lesson['startTime']) {
                  lessonNumber = timeslotIndex;
                }
              });
              for (; lessonNumber < timeslots.length; lessonNumber++) {
                if (lesson.containsKey('changes') || lessons[lessonNumber][weekdayIndex].freeTime) {
                  lessons[lessonNumber][weekdayIndex] = Lesson.fromJson(lesson, datesOfWeek[weekdayIndex], lessonNumber);
                }
                if (lesson['endTime'] == timeslots[lessonNumber]['endTime']) {
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
              0: FixedColumnWidth(60),
            },
          ),
        ),
      ),
    );
  }
}
