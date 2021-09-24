import 'package:date_format/date_format.dart';
import 'package:davinki/constants.dart';
import 'package:flutter/material.dart';

class DateCell extends StatelessWidget {
  final DateTime _date;
  final DateTime _today = DateTime.now();
  DateCell(this._date, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10.0),
      child: Column(children: <Widget>[
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: (_date.year == _today.year &&
                    _date.month == _today.month &&
                    _date.day == _today.day)
                ? Colors.blue
                : Colors.pink,
          ),
          child: Text(
            formatDate(_date, <String>[dd, '.', mm]),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        Text(kWeekdayNames[_date.weekday - 1],
            style: const TextStyle(fontSize: 16)),
      ]),
    );
  }
}
