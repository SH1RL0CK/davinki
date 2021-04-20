import 'package:davinki/screens/weekly_timetable_screen/widgets/cancelled.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/lesson_timetable/lesson_timetable_dialog.dart';
import 'package:flutter/material.dart';
import 'package:davinki/models/lesson.dart';

class LessonCell extends StatefulWidget {
  final Lesson _lesson;
  final Map<String, dynamic> _infoserverData;
  LessonCell(this._lesson, this._infoserverData, {Key? key}) : super(key: key);

  @override
  _LessonCellState createState() => _LessonCellState(this._lesson, this._infoserverData);
}

class _LessonCellState extends State<LessonCell> {
  final Lesson _lesson;
  final Map<String, dynamic> _infoserverData;
  _LessonCellState(this._lesson, this._infoserverData) : super();
  @override
  Widget build(BuildContext context) {
    String courseTitle = (this._lesson.additional) ? '+ ' + this._lesson.course.title : this._lesson.course.title;
    return Container(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: this._lesson.freeTime ? Colors.transparent : Colors.white,
                  border: Border.all(color: this._lesson.color, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (courseTitle.length > 5) ? courseTitle.substring(0, 5) : courseTitle,
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        (this._lesson.newTeacher != '') ? this._lesson.newTeacher : this._lesson.course.teacher,
                        style: TextStyle(
                          fontSize: 13,
                          color: (this._lesson.newTeacher != '') ? Colors.red.shade900 : Colors.black,
                          fontWeight: (this._lesson.newTeacher != '') ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        (this._lesson.newRoom != '') ? this._lesson.newRoom : this._lesson.room,
                        style: TextStyle(
                          fontSize: 13,
                          color: (this._lesson.newRoom != '') ? Colors.red.shade900 : Colors.black,
                          fontWeight: (this._lesson.newRoom != '') ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Cancelled(this._lesson),
            ],
          ),
        ),
        onTap: () {
          LessonTimetableDialog dialog = LessonTimetableDialog(this._lesson, this._infoserverData, key: UniqueKey());
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
      ),
    );
  }
}
