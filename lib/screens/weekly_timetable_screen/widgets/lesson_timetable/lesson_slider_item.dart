import 'package:davinki/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonSliderItem extends StatefulWidget {
  final Lesson _lesson;
  const LessonSliderItem(this._lesson, {Key? key}) : super(key: key);

  @override
  _LessonSliderItemState createState() => _LessonSliderItemState(this._lesson);
}

class _LessonSliderItemState extends State<LessonSliderItem> {
  final Lesson _lesson;

  _LessonSliderItemState(this._lesson) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: this._lesson.color, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            this._lesson.changeCaption != ''
                ? Text(
                    this._lesson.changeCaption,
                    style: TextStyle(
                      backgroundColor: Colors.red.shade900,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                : Container(),
            this._lesson.changeInformation != ''
                ? Text(
                    this._lesson.changeInformation,
                    style: TextStyle(
                      backgroundColor: Colors.yellow[800],
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                : Container(),
            Text(
              this._lesson.course,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  this._lesson.newTeacher != ''
                      ? TextSpan(
                          text: this._lesson.teacher,
                          style: TextStyle(color: Colors.red[900], decoration: TextDecoration.lineThrough),
                        )
                      : TextSpan(),
                  TextSpan(text: this._lesson.newTeacher != '' ? '  ${this._lesson.newTeacher}' : this._lesson.teacher),
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
                          style: TextStyle(color: Colors.red[900], decoration: TextDecoration.lineThrough),
                        )
                      : TextSpan(),
                  TextSpan(text: this._lesson.newRoom != '' ? '  ${this._lesson.newRoom}' : this._lesson.room),
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
