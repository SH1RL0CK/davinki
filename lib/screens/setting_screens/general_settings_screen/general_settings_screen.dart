import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/user_type.dart';
import 'package:davinki/models/school_type.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/course_settings_screen.dart';
import 'package:davinki/widgets/info_dialog.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;

  GeneralSettingsScreen(this._generalSettings, this._courseSettings, {Key? key})
      : super(key: key);

  @override
  _GeneralSettingsScreenState createState() =>
      _GeneralSettingsScreenState(this._generalSettings, this._courseSettings);
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _infoserverData = <String, dynamic>{};

  bool _formFieldsEnabled = true;
  bool _wrongLoginData = false;
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _usernameInputController =
      TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  _GeneralSettingsScreenState(this._generalSettings, this._courseSettings) {
    this._nameInputController.text = this._generalSettings.name ?? '';
    this._usernameInputController.text = this._generalSettings.username ?? '';
  }

  Future<bool> _loginDataIsCorrect(String? username, String? password) async {
    try {
      this._infoserverData =
          await DavinciInfoserverService(username!, password!).getOnlineData();
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
      return false;
    } on WrongLoginDataException {
      setState(() {
        this._wrongLoginData = true;
        this._formFieldsEnabled = true;
      });
      return false;
    } on UnknownErrorException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return InfoDialog(
            'Unbekannter Fehler!',
            'Ein unbekannter Fehler ist während der Verbindung mit dem DAVINCI-Infoserver aufgetreten!',
          );
        },
      ).then((dynamic exit) {
        setState(() {
          this._formFieldsEnabled = true;
        });
      });
      return false;
    }

    return true;
  }

  String encryptPassword(String password) {
    return crypto.md5.convert(utf8.encode(password)).toString();
  }

  void _handleForm() async {
    if (!this._formFieldsEnabled) return;

    setState(() {
      this._wrongLoginData = false;
      this._formFieldsEnabled = false;
    });

    if (!this._formKey.currentState!.validate()) {
      setState(() {
        this._formFieldsEnabled = true;
      });
      return;
    }

    this._generalSettings.name = this._nameInputController.text;
    this._generalSettings.username = this._usernameInputController.text;
    String? encryptedPassword = this._passwordInputController.text.isEmpty
        ? this._generalSettings.encryptedPassword
        : encryptPassword(this._passwordInputController.text);

    if (!await this._loginDataIsCorrect(
        this._generalSettings.username, encryptedPassword)) return;

    this._generalSettings.encryptedPassword = encryptedPassword;
    this._generalSettings.storeData();
    if (this._generalSettings.userType == UserType.student) {
      navigateToOtherScreen(
        CourseSettingsScreen(
            this._infoserverData, this._generalSettings, this._courseSettings),
        context,
      );
    } else {
      navigateToOtherScreen(
        LoadingScreen(),
        context,
      );
    }
  }

  void _unfocusTextFields() {
    FocusScope.of(context).unfocus();
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
              if (this._formFieldsEnabled) {
                navigateToOtherScreen(
                  LoadingScreen(),
                  context,
                );
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: this._unfocusTextFields,
        child: Form(
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
                onTap: this._unfocusTextFields,
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
              this._generalSettings.userType == UserType.student
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: DropdownButtonFormField<SchoolType>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_balance),
                          labelText: 'Deine Schulform',
                        ),
                        value: this._generalSettings.schoolType,
                        onTap: this._unfocusTextFields,
                        onChanged: this._formFieldsEnabled
                            ? (SchoolType? newSchoolType) {
                                setState(() {
                                  this._generalSettings.schoolType =
                                      newSchoolType;
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
                    )
                  : Container(),
              this._generalSettings.schoolType == SchoolType.vocationalGymnasium
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.class_),
                          labelText: 'Deine Klasse',
                        ),
                        value: this._generalSettings.grade,
                        onTap: this._unfocusTextFields,
                        onChanged: this._formFieldsEnabled
                            ? (int? newGrade) {
                                setState(() {
                                  this._generalSettings.grade = newGrade;
                                });
                              }
                            : null,
                        validator: (int? grade) {
                          if (grade == null) {
                            return 'Bitte wähle Deine Klasse aus!';
                          }
                          return null;
                        },
                        items: <int>[11, 12, 13]
                            .map((int grade) => DropdownMenuItem<int>(
                                  child: Text(grade.toString()),
                                  value: grade,
                                ))
                            .toList(),
                      ),
                    )
                  : Container(),
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
                  errorText: this._wrongLoginData
                      ? 'Die Anmeldedaten sind falsch!'
                      : null,
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
                  labelText: this._generalSettings.encryptedPassword == null
                      ? 'Passwort'
                      : 'Neues Passwort',
                  errorText: this._wrongLoginData
                      ? 'Die Anmeldedaten sind falsch!'
                      : null,
                ),
                controller: this._passwordInputController,
                validator: (String? password) {
                  if (this._generalSettings.encryptedPassword == null &&
                      (password == null || password.isEmpty)) {
                    return 'Bitte gib Dein Passwort an!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              FloatingActionButton.extended(
                icon: Icon(Icons.save),
                label: Text(
                  this._generalSettings.userType == UserType.student
                      ? 'Zu Deinen Kursen'
                      : 'Speichern',
                ),
                onPressed: this._handleForm,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
