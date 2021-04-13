import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/screens/settings_screens/general_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/weekly_timetable_screen/weekly_timetable_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      String? username = sharedPreferences.getString('username');
      String? password = sharedPreferences.getString('password');
      if (username != null && password != null) {
        DavinciInfoserverService(username, password).getData().then((Map<String, dynamic> infoserverData) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WeeklyTimetableScreen(infoserverData)),
            (Route route) => false,
          );
        }, onError: (exception) {
          if (exception is WrongLoginDataException) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => GeneralSettingsScreen()),
              (Route route) => false,
            );
          }
        });
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                ),
              ),
            ),
            Text(
              'Dein Stundenplan wird geladen...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
