import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/screens/settings_screens/general_settings_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/weekly_timetable.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  WeeklyTimetableScreen(this._infoserverData);
  @override
  _WeeklyTimetableScreenState createState() => _WeeklyTimetableScreenState(this._infoserverData);
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  final Map<String, dynamic> _infoserverData;
  int _week = 0;
  _WeeklyTimetableScreenState(this._infoserverData);

  void _changeWeek(int i) {
    setState(() {
      if (!(i < 0 && this._week <= -2)) {
        this._week += i;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Davinki',
          style: GoogleFonts.pacifico(fontSize: 25),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => GeneralSettingsScreen()),
                (Route route) => false,
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            child: WeeklyTimetable(
              this._week,
              this.widget._infoserverData,
              key: UniqueKey(),
            ),
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity == 0) return;
              if (details.primaryVelocity!.compareTo(0) == -1)
                this._changeWeek(1);
              else
                this._changeWeek(-1);
            },
          ),
          this._week > -2
              ? Align(
                  alignment: Alignment(-0.99, 0.99),
                  child: FloatingActionButton(
                    onPressed: () => this._changeWeek(-1),
                    mini: true,
                    child: Icon(Icons.keyboard_arrow_left),
                    heroTag: null,
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment(0.99, 0.99),
            child: FloatingActionButton(
              onPressed: () => this._changeWeek(1),
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
