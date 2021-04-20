import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/user_type.dart';
import 'package:davinki/models/school_type.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/user_is_offline_screen/user_is_offline_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/course_settings_screen.dart';
import 'package:davinki/widgets/info_dialog.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;

  GeneralSettingsScreen(this._generalSettings, this._courseSettings, {Key? key}) : super(key: key);

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState(this._generalSettings, this._courseSettings);
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _infoserverData = <String, dynamic>{};

  bool _formFieldsEnabled = true;
  bool _wrongLoginData = false;
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _usernameInputController = TextEditingController();
  final TextEditingController _passwordInputController = TextEditingController();

  _GeneralSettingsScreenState(this._generalSettings, this._courseSettings) {
    this._nameInputController.text = this._generalSettings.name ?? '';
    this._usernameInputController.text = this._generalSettings.username ?? '';
  }

  @override
  void dispose() {
    this._nameInputController.dispose();
    this._usernameInputController.dispose();
    this._passwordInputController.dispose();
    super.dispose();
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
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToOtherScreen(
                LoadingScreen(),
                context,
              );
            },
          )
        ],
      ),
      body: Form(
        key: this._formKey,
        child: ListView(
          padding: EdgeInsets.all(12.0),
          children: <Widget>[
            Text(
              'Allgemeine Einstellungen',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 12),
            TextFormField(
              enabled: this._formFieldsEnabled,
              keyboardType: TextInputType.text,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                labelText: 'Dein Name',
              ),
              controller: this._nameInputController,
              validator: (String? name) {
                if (name == null || name.isEmpty) {
                  return 'Bitte gib Deinen Namen an!';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<UserType>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
                labelText: 'Du bist',
              ),
              value: this._generalSettings.userType,
              onChanged: this._formFieldsEnabled
                  ? (UserType? newUserType) {
                      setState(() {
                        this._generalSettings.userType = newUserType;
                      });
                    }
                  : null,
              validator: (UserType? userType) {
                if (userType == null) {
                  return 'Bitte gib an, was Du bist!';
                }
                return null;
              },
              items: <DropdownMenuItem<UserType>>[
                DropdownMenuItem<UserType>(
                  child: Text('Schüler'),
                  value: UserType.student,
                )
              ],
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<SchoolType>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
                labelText: 'Deine Schulform',
              ),
              value: this._generalSettings.schoolType,
              onChanged: this._formFieldsEnabled
                  ? (SchoolType? newSchoolType) {
                      setState(() {
                        this._generalSettings.schoolType = newSchoolType;
                      });
                    }
                  : null,
              validator: (SchoolType? schoolType) {
                if (schoolType == null) {
                  return 'Bitte wähle Deine Schulform aus!';
                }
                return null;
              },
              items: <DropdownMenuItem<SchoolType>>[
                DropdownMenuItem<SchoolType>(
                  child: Text('Berufliches Gymnasium'),
                  value: SchoolType.vocationalGymnasium,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Anmeldung',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 12),
            TextFormField(
              enabled: this._formFieldsEnabled,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'Benutzername',
                errorText: this._wrongLoginData ? 'Die Anmeldedaten sind falsch!' : null,
              ),
              controller: this._usernameInputController,
              validator: (String? username) {
                if (username == null || username.isEmpty) {
                  return 'Bitte gib Deinen Benutzernamen an!';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              enabled: this._formFieldsEnabled,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: this._generalSettings.password == null ? 'Passwort' : 'Neues Passwort',
                errorText: this._wrongLoginData ? 'Die Anmeldedaten sind falsch!' : null,
              ),
              controller: this._passwordInputController,
              validator: (String? password) {
                if (this._generalSettings.password == null && (password == null || password.isEmpty)) {
                  return 'Bitte gib Dein Passwort an!';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              icon: Icon(Icons.save),
              label: Text(
                'Zu Deinen Kursen',
              ),
              onPressed: this._formFieldsEnabled
                  ? () async {
                      setState(() {
                        this._wrongLoginData = false;
                        this._formFieldsEnabled = false;
                      });
                      if (this._formKey.currentState!.validate()) {
                        this._generalSettings.name = this._nameInputController.text;
                        this._generalSettings.username = this._usernameInputController.text;
                        this._generalSettings.password = this._passwordInputController.text.isEmpty ? this._generalSettings.password : this._passwordInputController.text;
                        try {
                          this._infoserverData = await DavinciInfoserverService(this._generalSettings.username!, this._generalSettings.password!).getOnlineData();
                        } on UserIsOfflineException {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InfoDialog(
                                'Du bist offline!',
                                'Du musst online sein, um die Einstellungen zu speichern!',
                              );
                            },
                          ).then((dynamic exit) {
                            setState(() {
                              this._formFieldsEnabled = true;
                            });
                          });
                          return;
                        } on WrongLoginDataException {
                          setState(() {
                            this._wrongLoginData = true;
                            this._formFieldsEnabled = true;
                          });
                          return;
                        }

                        this._generalSettings.storeData();
                        navigateToOtherScreen(
                          CourseSettingsScreen(this._courseSettings, this._infoserverData),
                          context,
                        );
                      } else {
                        setState(() {
                          this._formFieldsEnabled = true;
                        });
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
