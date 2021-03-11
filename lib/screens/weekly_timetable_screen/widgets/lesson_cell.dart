import 'package:DAVINKI/screens/weekly_timetable_screen/widgets/cancelled.dart';
import 'package:flutter/material.dart';
import 'package:DAVINKI/models/lesson.dart';

class LessonCell extends StatefulWidget {
  final Lesson _lesson;
  LessonCell(this._lesson) : super();

  @override
  _LessonCellState createState() => _LessonCellState(this._lesson);
}

class _LessonCellState extends State<LessonCell> {
  final Lesson _lesson;
  _LessonCellState(this._lesson) : super();
  @override
  Widget build(BuildContext context) {
    if (this._lesson.freeTime) {
      return Container();
    }
    String courseTitle = (this._lesson.additional) ? '+ ' + this._lesson.course : this._lesson.course;
    return Container(
      child: InkWell(
        onTap: () => print(this._lesson.course),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: (!this._lesson.cancelled) ? Color(this._lesson.color) : Color(this._lesson.color),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  /*boxShadow: [
                    BoxShadow(
                      color: Colors.pink,
                      spreadRadius: (this._lesson.currentLesson == true) ? 2 : 0,
                      blurRadius: (this._lesson.currentLesson == true) ? 5 : 0,
                      offset: Offset(0, 0), // Shadow position
                    ),
                  ],
                  */
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (this._lesson.course.length > 5) ? courseTitle.substring(0, 5) : courseTitle,
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        (this._lesson.newTeacher != '') ? this._lesson.newTeacher : this._lesson.teacher,
                        style: TextStyle(
                          fontSize: 13,
                          color: (this._lesson.newTeacher != '') ? Colors.red[900] : Colors.white,
                          fontWeight: (this._lesson.newTeacher != '') ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      Text(
                        (this._lesson.newRoom != '') ? this._lesson.newRoom : this._lesson.room,
                        style: TextStyle(
                          fontSize: 13,
                          color: (this._lesson.newRoom != '') ? Colors.red[900] : Colors.white,
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
      ),
    );
  }
}
