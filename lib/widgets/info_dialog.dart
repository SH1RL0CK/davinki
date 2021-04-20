import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String _title;
  final String _info;
  const InfoDialog(this._title, this._info, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._title),
      content: Text(this._info),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
    );
  }
}
