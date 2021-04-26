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
  _WeeklyTimetableState(this._week, this._infoserverData, this._courseSettings);

  List<List<Lesson>> _getLessonsOfTimetable(List lessonTimes, List timeslots, List<DateTime> datesOfWeek) {
    List<List<Lesson>> lessons = List<List<Lesson>>.generate(
      timeslots.length,
      (int lessonNumber) => datesOfWeek
          .map(
            (DateTime date) => Lesson(date, lessonNumber, freeTime: true),
          )
          .toList(),
    );

    List<String> formatedDatesOfWeek = datesOfWeek.map((DateTime date) => infoserverDateFormat(date)).toList();

    for (Map<String, dynamic> lessonAsMap in lessonTimes) {
      if (!Lesson.isLesson(lessonAsMap)) {
        continue;
      }
      Lesson lesson = Lesson.fromJson(lessonAsMap);
      bool isUsersLesson = this._courseSettings.usersCourses.contains(lesson.course);
      if (isUsersLesson) {
        formatedDatesOfWeek.asMap().forEach(
          (int weekdayIndex, String date) {
            if (lessonAsMap['dates'].contains(date)) {
              int lessonNumber = 0;
              timeslots.asMap().forEach((timeslotIndex, timeslot) {
                if (timeslot['startTime'] == lessonAsMap['startTime']) {
                  lessonNumber = timeslotIndex;
                }
              });
              for (; lessonNumber < timeslots.length; lessonNumber++) {
                if ((lesson.changeCaption.isNotEmpty && !lessons[lessonNumber][weekdayIndex].additional) ||
                    lessons[lessonNumber][weekdayIndex].freeTime) {
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

    List<List<Lesson>> timetable = _getLessonsOfTimetable(lessonTimes, timeslots, datesOfWeek);

    List<TableCell> firstRow = <TableCell>[TableCell(child: Container())];

    datesOfWeek.forEach((DateTime date) {
      firstRow.add(TableCell(child: DateCell(date)));
    });

    return <TableRow>[
          TableRow(
            children: <TableCell>[
                  TableCell(
                    child: Container(),
                  ),
                ] +
                datesOfWeek
                    .map(
                      (DateTime date) => TableCell(
                        child: DateCell(date),
                      ),
                    )
                    .toList(),
            decoration: BoxDecoration(color: Colors.white),
          )
        ] +
        List<TableRow>.generate(timetable.length, (int index) {
          return TableRow(
            children: <TableCell>[
                  TableCell(
                    child: TimeslotCell(timeslots[index]),
                  ),
                ] +
                timetable[index]
                    .map(
                      (Lesson lesson) => TableCell(
                        child: LessonCell(lesson, this._infoserverData),
                      ),
                    )
                    .toList(),
            decoration: BoxDecoration(
              color: (index % 2 == 0) ? Colors.pink[50] : Colors.white,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: this._buildTimetable(),
      columnWidths: {
        0: FixedColumnWidth(58),
      },
    );
  }
}
