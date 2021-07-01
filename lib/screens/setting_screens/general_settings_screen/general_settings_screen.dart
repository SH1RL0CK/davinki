import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/school_type.dart';
import 'package:davinki/models/user_type.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/course_settings_screen.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/widgets/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;

  const GeneralSettingsScreen(this._generalSettings, this._courseSettings,
      {Key? key})
      : super(key: key);

  @override
  _GeneralSettingsScreenState createState() =>
      _GeneralSettingsScreenState(_generalSettings, _courseSettings);
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _infoserverData = <String, dynamic>{};

  bool _formFieldsEnabled = true;
  bool _wrongLoginData = false;
  final TextEditingController _usernameInputController =
      TextEditingController();
  final TextEditingController _passwordInputController =
      TextEditingController();

  _GeneralSettingsScreenState(this._generalSettings, this._courseSettings) {
    _usernameInputController.text = _generalSettings.username ?? '';
  }

  Future<bool> _loginDataIsCorrect(String? username, String? password) async {
    try {
      _infoserverData =
          await DavinciInfoserverService(username!, password!).getOnlineData();
    } on UserIsOfflineException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const InfoDialog(
            'Du bist offline!',
            'Du musst online sein, um die Einstellungen zu speichern!',
          );
        },
      ).then((dynamic exit) {
        setState(() {
          _formFieldsEnabled = true;
        });
      });
      return false;
    } on WrongLoginDataException {
      setState(() {
        _wrongLoginData = true;
        _formFieldsEnabled = true;
      });
      return false;
    } on UnknownErrorException {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const InfoDialog(
            'Unbekannter Fehler!',
            'Ein unbekannter Fehler ist während der Verbindung mit dem DAVINCI-Infoserver aufgetreten!',
          );
        },
      ).then((dynamic exit) {
        setState(() {
          _formFieldsEnabled = true;
        });
      });
      return false;
    }

    return true;
  }

  String encryptPassword(String password) {
    return crypto.md5.convert(utf8.encode(password)).toString();
  }

  Future<void> _handleForm() async {
    if (!_formFieldsEnabled) return;

    setState(() {
      _wrongLoginData = false;
      _formFieldsEnabled = false;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _formFieldsEnabled = true;
      });
      return;
    }

    _generalSettings.username = _usernameInputController.text;
    final String? encryptedPassword = _passwordInputController.text.isEmpty
        ? _generalSettings.encryptedPassword
        : encryptPassword(_passwordInputController.text);

    if (!await _loginDataIsCorrect(
        _generalSettings.username, encryptedPassword)) return;

    _generalSettings.encryptedPassword = encryptedPassword;
    _generalSettings.storeData();
    if (_generalSettings.userType == UserType.student) {
      navigateToOtherScreen(
        CourseSettingsScreen(
            _infoserverData, _generalSettings, _courseSettings),
        context,
      );
    } else {
      navigateToOtherScreen(
        const LoadingScreen(),
        context,
      );
    }
  }

  void _unfocusTextFields() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _usernameInputController.dispose();
    _passwordInputController.dispose();
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
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              if (_formFieldsEnabled) {
                navigateToOtherScreen(
                  const LoadingScreen(),
                  context,
                );
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: _unfocusTextFields,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: <Widget>[
              const Text(
                'Allgemeine Einstellungen',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<UserType>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                  labelText: 'Du bist',
                ),
                value: _generalSettings.userType,
                onTap: _unfocusTextFields,
                onChanged: _formFieldsEnabled
                    ? (UserType? newUserType) {
                        setState(() {
                          _generalSettings.userType = newUserType;
                        });
                      }
                    : null,
                validator: (UserType? userType) {
                  if (userType == null) {
                    return 'Bitte gib an, was Du bist!';
                  }
                  return null;
                },
                items: const <DropdownMenuItem<UserType>>[
                  DropdownMenuItem<UserType>(
                    value: UserType.student,
                    child: Text('Schüler'),
                  )
                ],
              ),
              if (_generalSettings.userType == UserType.student)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: DropdownButtonFormField<SchoolType>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance),
                      labelText: 'Deine Schulform',
                    ),
                    value: _generalSettings.schoolType,
                    onTap: _unfocusTextFields,
                    onChanged: _formFieldsEnabled
                        ? (SchoolType? newSchoolType) {
                            setState(() {
                              _generalSettings.schoolType = newSchoolType;
                            });
                          }
                        : null,
                    validator: (SchoolType? schoolType) {
                      if (schoolType == null) {
                        return 'Bitte wähle Deine Schulform aus!';
                      }
                      return null;
                    },
                    items: const <DropdownMenuItem<SchoolType>>[
                      DropdownMenuItem<SchoolType>(
                        value: SchoolType.vocationalGymnasium,
                        child: Text('Berufliches Gymnasium'),
                      ),
                    ],
                  ),
                )
              else
                Container(),
              if (_generalSettings.schoolType == SchoolType.vocationalGymnasium)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.class_),
                      labelText: 'Deine Klasse',
                    ),
                    value: _generalSettings.grade,
                    onTap: _unfocusTextFields,
                    onChanged: _formFieldsEnabled
                        ? (int? newGrade) {
                            setState(() {
                              _generalSettings.grade = newGrade;
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
                              value: grade,
                              child: Text(grade.toString()),
                            ))
                        .toList(),
                  ),
                )
              else
                Container(),
              const SizedBox(height: 20),
              const Text(
                'Anmeldung',
                style: TextStyle(fontSize: 25),
              ),
              const Text(
                'Gib bitte Deine DAVINCI-Anmeldedaten an.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 15),
              TextFormField(
                enabled: _formFieldsEnabled,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                  labelText: 'Benutzername',
                  errorText:
                      _wrongLoginData ? 'Die Anmeldedaten sind falsch!' : null,
                ),
                controller: _usernameInputController,
                validator: (String? username) {
                  if (username == null || username.isEmpty) {
                    return 'Bitte gib Deinen Benutzernamen an!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                enabled: _formFieldsEnabled,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  labelText: _generalSettings.encryptedPassword == null
                      ? 'Passwort'
                      : 'Neues Passwort',
                  errorText:
                      _wrongLoginData ? 'Die Anmeldedaten sind falsch!' : null,
                ),
                controller: _passwordInputController,
                validator: (String? password) {
                  if (_generalSettings.encryptedPassword == null &&
                      (password == null || password.isEmpty)) {
                    return 'Bitte gib Dein Passwort an!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton.extended(
                icon: const Icon(Icons.save),
                label: Text(
                  _generalSettings.userType == UserType.student
                      ? 'Zu Deinen Kursen'
                      : 'Speichern',
                ),
                onPressed: _handleForm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
