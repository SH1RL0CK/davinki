import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/setting_screens/general_settings_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/weekly_timetable_screen.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final GeneralSettings _generalSettings = GeneralSettings();
  final CourseSettings _courseSettings = CourseSettings();

  void _navigateToSettings() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GeneralSettingsScreen(this._generalSettings, this._courseSettings)),
      (Route route) => false,
    );
  }

  void _navigateToWeeklyTimetable(Map<String, dynamic> infoserverData, bool offline) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WeeklyTimetableScreen(infoserverData, offline, this._generalSettings, this._courseSettings)),
      (Route route) => false,
    );
  }

  void _loadInofoserverData() {
    DavinciInfoserverService infoserverService = DavinciInfoserverService(this._generalSettings.username!, this._generalSettings.password!);
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

  void _laodRequiredData() {
    this._generalSettings.loadData().then((bool generalSettingsAreAvailable) {
      this._courseSettings.loadData().then((bool courseSettingsAreAvailable) {
        if (!generalSettingsAreAvailable || !courseSettingsAreAvailable) {
          this._navigateToSettings();
          return;
        }
        this._loadInofoserverData();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this._laodRequiredData();
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
