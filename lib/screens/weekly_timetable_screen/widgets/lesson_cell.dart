import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/cancelled.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_timetable/lesson_timetable_dialog.dart';
import 'package:flutter/material.dart';

class LessonCell extends StatelessWidget {
  final Lesson _lesson;
  final Map<String, dynamic> _infoserverData;
  const LessonCell(this._lesson, this._infoserverData, {Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final String courseTitle = (_lesson.additional)
        ? '+ ${_lesson.course.title}'
        : _lesson.course.title;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: _lesson.freeTime ? Colors.transparent : Colors.white,
                border: Border.all(color: _lesson.color, width: 3),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Text>[
                    Text(
                      courseTitle,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      (_lesson.newTeacher != '')
                          ? _lesson.newTeacher
                          : _lesson.course.teacher,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13,
                        color: (_lesson.newTeacher != '')
                            ? Colors.red.shade900
                            : Colors.black,
                        fontWeight: (_lesson.newTeacher != '')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      (_lesson.newRoom != '') ? _lesson.newRoom : _lesson.room,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13,
                        color: (_lesson.newRoom != '')
                            ? Colors.red.shade900
                            : Colors.black,
                        fontWeight: (_lesson.newRoom != '')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Cancelled(_lesson),
          ],
        ),
      ),
      onTap: () {
        final LessonTimetableDialog dialog =
            LessonTimetableDialog(_lesson, _infoserverData, key: UniqueKey());
        if (dialog.empty) {
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );
      },
    );
  }
}
