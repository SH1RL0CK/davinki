import 'package:flutter/material.dart';

class TimeslotCell extends StatelessWidget {
  final Map _timeslot;
  TimeslotCell(this._timeslot);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            ' ${this._timeslot['startTime'][0] + this._timeslot['startTime'][1]}:${this._timeslot['startTime'][2] + this._timeslot['startTime'][3]}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            '${this._timeslot['label']}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${this._timeslot['endTime'][0] + this._timeslot['endTime'][1]}:${this._timeslot['endTime'][2] + this._timeslot['endTime'][3]}',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
