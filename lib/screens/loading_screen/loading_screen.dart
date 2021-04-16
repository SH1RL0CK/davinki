import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/screens/setting_screens/general_settings_screen.dart';
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
  bool _requiredSettingsAreMissing(SharedPreferences sharedPreferences) {
    bool missing = false;
    for (String key in <String>['name', 'userType', 'schoolType', 'username', 'password']) {
      if (sharedPreferences.getString(key) == null) {
        missing = true;
      }
    }
    return missing;
  }

  void _navigateToSettings() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GeneralSettingsScreen()),
      (Route route) => false,
    );
  }

  void _navigateToWeeklyTimetable(Map<String, dynamic> infoserverData, bool offline) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WeeklyTimetableScreen(infoserverData, offline)),
      (Route route) => false,
    );
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      if (this._requiredSettingsAreMissing(sharedPreferences)) {
        this._navigateToSettings();
        return;
      }

      String? username = sharedPreferences.getString('username');
      String? password = sharedPreferences.getString('password');
      if (username != null && password != null) {
        DavinciInfoserverService infoserverService = DavinciInfoserverService(username, password);
        infoserverService.getOnlineData().then((Map<String, dynamic> infoserverData) {
          this._navigateToWeeklyTimetable(infoserverData, false);
        }, onError: (exception) {
          if (exception is WrongLoginDataException) {
            this._navigateToSettings();
            return;
          } else if (exception is UserIsOfflineException) {
            infoserverService.getOfflineData().then((Map<String, dynamic> infoserverData) {
              this._navigateToWeeklyTimetable(infoserverData, true);
            });
          }
        });
      }
    });
    super.initState();
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
