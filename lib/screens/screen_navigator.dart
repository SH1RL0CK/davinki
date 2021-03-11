import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:DAVINKI/screens/home_screen/home_screen.dart';
import 'package:DAVINKI/screens/weekly_timetable_screen/weekly_timetable_screen.dart';
import 'package:DAVINKI/screens/school_planner_screen/school_planner_screen.dart';
import 'package:DAVINKI/screens/settings_screen/settings_screen.dart';

class ScreenNavigator extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  ScreenNavigator(this._infoserverData);

  @override
  _ScreenNavigatorState createState() => _ScreenNavigatorState(this._infoserverData);
}

class _ScreenNavigatorState extends State<ScreenNavigator> {
  int _currentIndex = 0;
  List<Widget> _screens;
  final Map<String, dynamic> _infoserverData;

  _ScreenNavigatorState(this._infoserverData) {
    this._screens = <Widget>[
      HomeScreen(),
      WeeklyTimetableScreen(this._infoserverData),
      //SchoolPlannerScreen(),
    ];
  }
  void _onTabTapped(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

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
      body: this._screens.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Stundenplan',
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Schulplaner',
          )
          */
        ],
        onTap: this._onTabTapped,
      ),
    );
  }
}
