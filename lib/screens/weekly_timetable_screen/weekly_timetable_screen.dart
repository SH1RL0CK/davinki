import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/screens/setting_screens/general_settings_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/widgets/weekly_timetable.dart';

class WeeklyTimetableScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  final bool _offline;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  WeeklyTimetableScreen(this._infoserverData, this._offline, this._generalSettings, this._courseSettings);
  @override
  _WeeklyTimetableScreenState createState() =>
      _WeeklyTimetableScreenState(this._infoserverData, this._offline, this._generalSettings, this._courseSettings);
}

class _WeeklyTimetableScreenState extends State<WeeklyTimetableScreen> {
  final Map<String, dynamic> _infoserverData;
  final bool _offline;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  int _week = 0;
  _WeeklyTimetableScreenState(this._infoserverData, this._offline, this._generalSettings, this._courseSettings);

  @override
  void initState() {
    super.initState();
    if (this._offline) {
      WidgetsBinding.instance!.addPostFrameCallback((Duration timestamp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[800],
            duration: Duration(seconds: 5),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Du bist offline!',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

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
                MaterialPageRoute(builder: (context) => GeneralSettingsScreen(this._generalSettings, this._courseSettings)),
                (Route route) => false,
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: this._week > -2,
              child: FloatingActionButton(
                onPressed: () => this._changeWeek(-1),
                mini: true,
                child: Icon(Icons.keyboard_arrow_left),
                heroTag: null,
              ),
            ),
            FloatingActionButton(
              onPressed: () => this._changeWeek(1),
              mini: true,
              child: Icon(Icons.keyboard_arrow_right),
              heroTag: null,
            ),
          ],
        ),
      ),
      body: GestureDetector(
        child: WeeklyTimetable(
          this._week,
          this._infoserverData,
          this._courseSettings,
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
    );
  }
}
