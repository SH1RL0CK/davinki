import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:davinki/models/user_type.dart';
import 'package:davinki/models/school_type.dart';
import 'package:davinki/models/davinci_infoserver_service_exceptions.dart';
import 'package:davinki/services/davinci_infoserver_service.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/settings_screens/courses_settings_screen.dart';

class GeneralSettingsScreen extends StatefulWidget {
  GeneralSettingsScreen({Key? key}) : super(key: key);

  @override
  _GeneralSettingsScreenState createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _infoserverData = <String, dynamic>{};

  bool _formFieldsEnabled = true;
  bool _loadingForFirstTime = true;
  bool _wrongLoginData = false;
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _usernameInputController = TextEditingController();
  final TextEditingController _passwordInputController = TextEditingController();
  UserType? _userType;
  SchoolType? _schoolType;
  String? _password;

  _GeneralSettingsScreenState();

  Future<bool> _getSharedPreferences() async {
    if (this._loadingForFirstTime) {
      this._loadingForFirstTime = false;
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? name = sharedPreferences.getString('name');
      String? userType = sharedPreferences.getString('userType');
      String? schoolType = sharedPreferences.getString('schoolType');
      String? username = sharedPreferences.getString('username');
      String? password = sharedPreferences.getString('password');
      if (name != null) this._nameInputController.text = name;
      if (userType != null) this._userType = EnumToString.fromString(UserType.values, userType);
      if (schoolType != null) this._schoolType = EnumToString.fromString(SchoolType.values, schoolType);
      if (username != null) this._usernameInputController.text = username;
      if (password != null) this._password = password;
    }
    return true;
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen()),
                (Route route) => false,
              );
            },
          )
        ],
      ),
      body: FutureBuilder<bool>(
        future: this._getSharedPreferences(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(12.0),
              child: Form(
                key: this._formKey,
                child: ListView(
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
                      value: this._userType,
                      onChanged: this._formFieldsEnabled
                          ? (UserType? newUserType) {
                              setState(() {
                                this._userType = newUserType;
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
                      value: this._schoolType,
                      onChanged: this._formFieldsEnabled
                          ? (SchoolType? newSchoolType) {
                              setState(() {
                                this._schoolType = newSchoolType;
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
                        labelText: this._password == null ? 'Passwort' : 'Neues Passwort',
                        errorText: this._wrongLoginData ? 'Die Anmeldedaten sind falsch!' : null,
                      ),
                      controller: this._passwordInputController,
                      validator: (String? password) {
                        if (this._password == null && (password == null || password.isEmpty)) {
                          return 'Bitte gib Dein Passwort an!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    FloatingActionButton.extended(
                      icon: Icon(Icons.save),
                      onPressed: this._formFieldsEnabled
                          ? () async {
                              setState(() {
                                this._wrongLoginData = false;
                                this._formFieldsEnabled = false;
                              });
                              if (this._formKey.currentState!.validate()) {
                                this._password = this._passwordInputController.text.isEmpty ? this._password! : this._passwordInputController.text;
                                try {
                                  this._infoserverData =
                                      await DavinciInfoserverService(this._usernameInputController.text, this._password!).getOnlineData();
                                } on WrongLoginDataException {
                                  setState(() {
                                    this._wrongLoginData = true;
                                    this._formFieldsEnabled = true;
                                  });
                                  return;
                                }
                                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                sharedPreferences.setString('name', this._nameInputController.text);
                                sharedPreferences.setString('userType', EnumToString.convertToString(this._userType!));
                                sharedPreferences.setString('schoolType', EnumToString.convertToString(this._schoolType!));
                                sharedPreferences.setString('username', this._usernameInputController.text);
                                sharedPreferences.setString('password', this._password!);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => CoursesSettings(this._infoserverData)),
                                  (Route route) => false,
                                );
                              } else {
                                setState(() {
                                  this._formFieldsEnabled = true;
                                });
                              }
                            }
                          : null,
                      label: Text(
                        'Zu Deinen Kursen',
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
