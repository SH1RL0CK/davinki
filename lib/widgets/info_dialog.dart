import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String _title;
  final String _body;
  const InfoDialog(this._title, this._body, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_body),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
