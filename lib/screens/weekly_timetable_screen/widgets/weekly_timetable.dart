import 'package:flutter/material.dart';
import 'package:DAVINKI/utils.dart';
import 'package:DAVINKI/secret.dart' as secret;
import 'package:DAVINKI/models/lesson.dart';
import 'package:DAVINKI/screens/weekly_timetable_screen/widgets/date_cell.dart';
import 'package:DAVINKI/screens/weekly_timetable_screen/widgets/lesson_cell.dart';
import 'package:DAVINKI/screens/weekly_timetable_screen/widgets/timseslot_cell.dart';

class WeeklyTimetable extends StatefulWidget {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  WeeklyTimetable(this._week, this._infoserverData, {Key key}) : super(key: key);

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

    datesOfWeek.forEach((date) => formatedDatesOfWeek.add(infoserverDateFormat(date)));

    for (int i = 0; i < timeslots.length; i++) {
      List<Lesson> l = <Lesson>[];
      for (int j = 0; j < 5; j++) {
        l.add(Lesson(freeTime: true));
      }
      lessons.add(l);
    }

    for (Map<String, dynamic> lesson in lessonTimes) {
      int color = 0;
      secret.mySubjects.forEach((subject) {
        if (subject.name == lesson['courseTitle'] && subject.teacher == lesson['teacherCodes'][0]) {
          color = subject.color;
        }
      });

      if (color != 0 && lesson['dates'].any((date) => formatedDatesOfWeek.contains(date))) {
        List<String> lessonInfo = <String>[];
        int lessonNumber = 0;
        int date = 0;
        if (lesson.containsKey('lessonBlock')) {
          lessonInfo = lesson['lessonBlock'].split('-');
          lessonNumber = int.parse(lessonInfo[2].split('.')[0]) - 1;
          Map<String, int> dates = {'Mo': 0, 'Di': 1, 'Mi': 2, 'Do': 3, 'Fr': 4};
          date = dates[lessonInfo[1]];
          if (lesson.containsKey('changes') || lessons[lessonNumber][date].freeTime) {
            lessons[lessonNumber][date] = Lesson.fromJson(lesson, color);
          }
        }
      }
    }
    lessons[2][0].currentLesson = true;
    return lessons;
  }

  List<TableRow> _buildTimetable() {
    List<DateTime> datesOfWeek = getDatesOfWeek(this._week);
    List lessonTimes = this._infoserverData['result']['displaySchedule']['lessonTimes'];
    List timeslots = this._infoserverData['result']['timeframes'][0]['timeslots'];

    List<List<Lesson>> lessons = _getLessons(lessonTimes, timeslots, datesOfWeek);

    List<TableCell> firstRow = <TableCell>[TableCell(child: Container())];

    datesOfWeek.forEach((date) {
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
        cells.add(TableCell(
          child: LessonCell(lessons[i][j]),
        ));
      }
      rows.add(TableRow(
          children: cells,
          decoration: BoxDecoration(
            color: (i % 2 == 0) ? Colors.pink[50] : Colors.white,
          )));
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
          ),
        ),
      ),
    );
  }
}