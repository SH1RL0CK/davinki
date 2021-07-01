import 'package:davinki/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonSliderItem extends StatelessWidget {
  final Lesson _lesson;

  LessonSliderItem(this._lesson, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: this._lesson.color, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            this._lesson.changeCaption != ''
                ? Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      this._lesson.changeCaption,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Container(),
            this._lesson.changeInformation != ''
                ? Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade800,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      this._lesson.changeInformation,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  )
                : Container(),
            Text(
              this._lesson.course.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              this._lesson.classes.join(', '),
              style: TextStyle(fontSize: 18),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  this._lesson.newTeacher != ''
                      ? TextSpan(
                          text: this._lesson.course.teacher,
                          style: TextStyle(
                              color: Colors.red.shade900,
                              decoration: TextDecoration.lineThrough),
                        )
                      : TextSpan(),
                  TextSpan(
                      text: this._lesson.newTeacher != ''
                          ? '  ${this._lesson.newTeacher}'
                          : this._lesson.course.teacher),
                ],
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  this._lesson.newRoom != ''
                      ? TextSpan(
                          text: this._lesson.room,
                          style: TextStyle(
                              color: Colors.red.shade900,
                              decoration: TextDecoration.lineThrough),
                        )
                      : TextSpan(),
                  TextSpan(
                      text: this._lesson.newRoom != ''
                          ? '  ${this._lesson.newRoom}'
                          : this._lesson.room),
                ],
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
