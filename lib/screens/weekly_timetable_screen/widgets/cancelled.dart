import 'package:flutter/material.dart';
import 'package:davinki/models/lesson.dart';

class Cancelled extends StatelessWidget {
  final Lesson _lesson;
  const Cancelled(this._lesson) : super();

  @override
  Widget build(BuildContext context) {
    if (this._lesson.cancelled) {
      return Icon(
        Icons.close,
        color: Colors.red[900],
        size: 65.0,
      );
    }
    return Container();
  }
}
