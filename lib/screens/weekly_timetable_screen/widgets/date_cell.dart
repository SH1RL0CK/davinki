import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:davinki/utils.dart';

class DateCell extends StatelessWidget {
  final DateTime _date;
  final DateTime _today = DateTime.now();
  DateCell(this._date, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5, top: 10.0),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: (this._date.year == this._today.year && this._date.month == this._today.month && this._date.day == this._today.day)
                ? Colors.blue
                : Colors.pink,
          ),
          child: Text(
            formatDate(this._date, [dd, '.', mm]),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        Text(weekdayNames[this._date.weekday - 1], style: TextStyle(fontSize: 16)),
      ]),
    );
  }
}
