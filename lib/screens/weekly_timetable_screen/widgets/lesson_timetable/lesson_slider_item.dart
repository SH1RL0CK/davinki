import 'package:davinki/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonSliderItem extends StatelessWidget {
  final Lesson _lesson;

  const LessonSliderItem(this._lesson, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _lesson.color, width: 5.0),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_lesson.changeCaption != '')
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _lesson.changeCaption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            else
              Container(),
            if (_lesson.changeInformation != '')
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(bottom: 3),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade800,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  _lesson.changeInformation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            else
              Container(),
            Text(
              _lesson.course.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              _lesson.classes.join(', '),
              style: const TextStyle(fontSize: 18),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  if (_lesson.newTeacher != '')
                    TextSpan(
                      text: _lesson.course.teacher,
                      style: TextStyle(
                          color: Colors.red.shade900,
                          decoration: TextDecoration.lineThrough),
                    )
                  else
                    const TextSpan(),
                  TextSpan(
                      text: _lesson.newTeacher != ''
                          ? '  ${_lesson.newTeacher}'
                          : _lesson.course.teacher),
                ],
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  if (_lesson.newRoom != '')
                    TextSpan(
                      text: _lesson.room,
                      style: TextStyle(
                          color: Colors.red.shade900,
                          decoration: TextDecoration.lineThrough),
                    )
                  else
                    const TextSpan(),
                  TextSpan(
                      text: _lesson.newRoom != ''
                          ? '  ${_lesson.newRoom}'
                          : _lesson.room),
                ],
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
