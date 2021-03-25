import 'package:flutter/material.dart';

class TimeslotCell extends StatelessWidget {
  final Map _timeslot;
  TimeslotCell(this._timeslot);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          Text(
            ' ${this._timeslot['startTime'].substring(0, 2)}:${this._timeslot['startTime'].substring(2)}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            '${this._timeslot['label']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${this._timeslot['endTime'].substring(0, 2)}:${this._timeslot['endTime'].substring(2)}',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
