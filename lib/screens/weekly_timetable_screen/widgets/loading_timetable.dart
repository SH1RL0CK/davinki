import 'package:flutter/material.dart';

class LoadingTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: SizedBox(
            width: 90,
            height: 90,
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
          ),
        ),
        Text(
          'Dein Stundenplan wird geladen...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ],
    ));
  }
}
