import 'package:davinki/models/lesson.dart';
import 'package:flutter/material.dart';

class Cancelled extends StatelessWidget {
  final Lesson _lesson;
  const Cancelled(this._lesson) : super();

  @override
  Widget build(BuildContext context) {
    if (_lesson.cancelled) {
      return Icon(
        Icons.close,
        color: Colors.red.shade900,
        size: 65.0,
      );
    }
    return Container();
  }
}
