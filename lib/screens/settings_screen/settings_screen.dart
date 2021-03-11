import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Dein Profil',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Dein Name'),
              ),
              DropdownButton(
                hint: Text('Du bist'),
                items: <DropdownMenuItem>[
                  DropdownMenuItem(value: 'student', child: Text('Schüler')),
                  DropdownMenuItem(value: 'teacher', child: Text('Lehrer')),
                ],
                onChanged: (value) {
                  print(value);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Text('hallo'),
            );
          },
        ),
        label: Text('Speichern'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
