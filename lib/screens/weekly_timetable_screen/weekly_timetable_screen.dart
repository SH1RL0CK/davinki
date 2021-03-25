import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/screens/settings_screen/settings_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/weekly_timetable.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  WeeklyTimetableScreen(this._infoserverData);
  @override
  _WeeklyTimetableScreenState createState() => _WeeklyTimetableScreenState();
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  int _currentWeek = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAVINKI',
          style: GoogleFonts.pacifico(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          WeeklyTimetable(
            this._currentWeek,
            this.widget._infoserverData,
            key: UniqueKey(),
          ),
          Align(
            alignment: Alignment(-0.99, 0.99),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  this._currentWeek--;
                });
              },
              mini: true,
              child: Icon(Icons.keyboard_arrow_left),
              heroTag: null,
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
              child: Icon(Icons.keyboard_arrow_right),
              heroTag: null,
            ),
          ),
        ],
      ),
    );
  }
}
