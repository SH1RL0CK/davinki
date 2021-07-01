import 'package:flutter/material.dart';

class TimeslotCell extends StatelessWidget {
  final Map<dynamic, dynamic> _timeslot;
  const TimeslotCell(this._timeslot);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: <Widget>[
          Text(
            ' ${_timeslot['startTime'].substring(0, 2)}:${_timeslot['startTime'].substring(2)}',
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            '${_timeslot['label']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_timeslot['endTime'].substring(0, 2)}:${_timeslot['endTime'].substring(2)}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
