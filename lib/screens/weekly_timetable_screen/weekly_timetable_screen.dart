import 'package:flutter/material.dart';
import 'package:DAVINKI/screens/weekly_timetable_screen/widgets/weekly_timetable.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  @override
  _WeeklyTimetableScreenState createState() => _WeeklyTimetableScreenState();
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  int _currentWeek = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        WeeklyTimetable(this._currentWeek, key: UniqueKey()),
        Align(
          alignment: Alignment(-0.99, 0.99),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                this._currentWeek--;
              });
            },
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        Align(
          alignment: Alignment(0.99, 0.99),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                this._currentWeek++;
              });
            },
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            child: Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }
}
