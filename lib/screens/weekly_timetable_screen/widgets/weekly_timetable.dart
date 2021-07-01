import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/date_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_cell.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/timseslot_cell.dart';
import 'package:davinki/utils.dart';
import 'package:flutter/material.dart';

class WeeklyTimetable extends StatelessWidget {
  final int _week;
  final Map<String, dynamic> _infoserverData;
  final CourseSettings _courseSettings;
  const WeeklyTimetable(this._week, this._infoserverData, this._courseSettings,
      {Key? key})
      : super(key: key);

  List<List<Lesson>> _getLessonsOfTimetable(List<dynamic> lessonTimes,
      List<dynamic> timeslots, List<DateTime> datesOfWeek) {
    final List<List<Lesson>> lessons = List<List<Lesson>>.generate(
      timeslots.length,
      (int lessonNumber) => datesOfWeek
          .map(
            (DateTime date) => Lesson(date, lessonNumber, freeTime: true),
          )
          .toList(),
    );

    final List<String> formatedDatesOfWeek =
        datesOfWeek.map((DateTime date) => infoserverDateFormat(date)).toList();

    for (final dynamic lessonAsMap in lessonTimes) {
      if (!Lesson.isLesson(lessonAsMap as Map<String, dynamic>)) {
        continue;
      }
      final Lesson lesson = Lesson.fromJson(lessonAsMap);
      final bool isUsersLesson =
          _courseSettings.usersCourses.contains(lesson.course);
      if (isUsersLesson) {
        formatedDatesOfWeek.asMap().forEach(
          (int weekdayIndex, String date) {
            if (lessonAsMap['dates'].contains(date) as bool) {
              int lessonNumber = 0;
              timeslots.asMap().forEach((int timeslotIndex, dynamic timeslot) {
                if (timeslot['startTime'] == lessonAsMap['startTime']) {
                  lessonNumber = timeslotIndex;
                }
              });
              for (; lessonNumber < timeslots.length; lessonNumber++) {
                if ((lesson.changeCaption.isNotEmpty &&
                        !lessons[lessonNumber][weekdayIndex].additional) ||
                    lessons[lessonNumber][weekdayIndex].freeTime) {
                  lesson.date = datesOfWeek[weekdayIndex];
                  lesson.formattedDate = infoserverDateFormat(lesson.date);
                  lesson.lessonNumber = lessonNumber;
                  lessons[lessonNumber][weekdayIndex] = lesson;
                }
                if (lessonAsMap['endTime'] ==
                    timeslots[lessonNumber]['endTime']) {
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
    final List<DateTime> datesOfWeek = getDatesOfWeek(_week);
    final List<dynamic> lessonTimes = _infoserverData['result']
        ['displaySchedule']['lessonTimes'] as List<dynamic>;
    final List<dynamic> timeslots = _infoserverData['result']['timeframes'][0]
        ['timeslots'] as List<dynamic>;

    final List<List<Lesson>> timetable =
        _getLessonsOfTimetable(lessonTimes, timeslots, datesOfWeek);

    return <TableRow>[
          TableRow(
            children: <TableCell>[
                  TableCell(
                    child: Container(),
                  ),
                ] +
                datesOfWeek
                    .map((DateTime date) => TableCell(
                          child: DateCell(date),
                        ))
                    .toList(),
            decoration: const BoxDecoration(),
          )
        ] +
        List<TableRow>.generate(timetable.length, (int index) {
          return TableRow(
            children: <TableCell>[
                  TableCell(
                    child:
                        TimeslotCell(timeslots[index] as Map<dynamic, dynamic>),
                  ),
                ] +
                timetable[index]
                    .map(
                      (Lesson lesson) => TableCell(
                        child: LessonCell(lesson, _infoserverData),
                      ),
                    )
                    .toList(),
            decoration: BoxDecoration(
              color: (index % 2 == 0) ? Colors.pink.shade50 : Colors.white,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTimetable(),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(58),
      },
    );
  }
}
