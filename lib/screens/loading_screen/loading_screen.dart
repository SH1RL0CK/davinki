import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/setting_screens/general_settings_screen/general_settings_screen.dart';
import 'package:davinki/screens/user_is_offline_screen/user_is_offline_screen.dart';
import 'package:davinki/screens/weekly_timetable_screen/weekly_timetable_screen.dart';
import 'package:davinki/widgets/info_dialog.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  final GeneralSettings _generalSettings = GeneralSettings();
  final CourseSettings _courseSettings = CourseSettings();

  void _navigateToSettings() {
    navigateToOtherScreen(
      GeneralSettingsScreen(this._generalSettings, this._courseSettings),
      context,
    );
  }

  void _navigateToWeeklyTimetable(Map<String, dynamic> infoserverData,
      {bool offline = false}) {
    navigateToOtherScreen(
      WeeklyTimetableScreen(
          infoserverData, this._generalSettings, this._courseSettings,
          offline: offline),
      context,
    );
  }

  void _showInfoDialog(
      String dialogTitle, String dialogBody, Function onClose) {
    setState(() {
      this._isLoading = false;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(dialogTitle, dialogBody);
      },
    ).then((dynamic exit) => onClose());
  }

  void _loadOfflineInfoserverData(DavinciInfoserverService infoserverService) {
    infoserverService.getOfflineData().then(
        (Map<String, dynamic> infoserverData) {
      this._navigateToWeeklyTimetable(infoserverData, offline: true);
    }, onError: (dynamic exception) {
      if (exception is NoOfflineDataExeption) {
        this._showInfoDialog(
          'Kein Offline Stundenplan gefunden!',
          'Bitte gehe online, um Deinen Stundenplan zu sehen!',
          () => navigateToOtherScreen(UserIsOfflineScreen(), context),
        );
      }
    });
  }

  void _loadInofoserverData() {
    DavinciInfoserverService infoserverService = DavinciInfoserverService(
        this._generalSettings.username!,
        this._generalSettings.encryptedPassword!);
    infoserverService.getOnlineData().then(
        (Map<String, dynamic> infoserverData) {
      this._navigateToWeeklyTimetable(infoserverData);
    }, onError: (dynamic exception) {
      if (exception is WrongLoginDataException) {
        this._showInfoDialog(
          'Falsche Anmeldededaten!',
          'Die Anmeldedaten für den DAVINCI-Infoserver sind falsch. Bitte korrigiere sie in den Einstellungen!',
          this._navigateToSettings,
        );
      } else if (exception is UserIsOfflineException) {
        this._loadOfflineInfoserverData(infoserverService);
      } else if (exception is UnknownErrorException) {
        this._showInfoDialog(
          'Unbekannter Fehler!',
          'Ein unbekannter Fehler ist während der Verbindung mit dem DAVINCI-Infoserver aufgetreten!',
          () => this._loadOfflineInfoserverData(infoserverService),
        );
      }
    });
  }

  void _laodRequiredData() {
    this._generalSettings.loadData().then((bool generalSettingsAreAvailable) {
      this._courseSettings.loadData().then((bool courseSettingsAreAvailable) {
        if (!generalSettingsAreAvailable || !courseSettingsAreAvailable) {
          this._showInfoDialog(
            'Willkommen!',
            'Bitte mache zunächst ein paar wichtige Einstellungen, damit Du die App richtig nutzen kannst.',
            this._navigateToSettings,
          );
        } else {
          this._loadInofoserverData();
        }
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
      body: this._isLoading
          ? Center(
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
            )
          : Container(),
    );
  }
}
