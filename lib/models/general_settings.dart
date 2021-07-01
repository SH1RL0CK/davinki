import 'package:davinki/models/school_type.dart';
import 'package:davinki/models/user_type.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettings {
  UserType? userType;
  SchoolType? schoolType;
  int? grade;
  String? username;
  String? encryptedPassword;

  String _usertypeKey = 'userType';
  String _schoolTypeKey = 'schoolType';
  String _gradeKey = 'grade';
  String _usernameKey = 'username';
  String _passwordKey = 'password';

  Future<bool> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userType = sharedPreferences.getString(this._usertypeKey);
    this.userType = EnumToString.fromString(UserType.values, userType ?? '');
    String? schoolType = sharedPreferences.getString(this._schoolTypeKey);
    this.grade = sharedPreferences.getInt(this._gradeKey);
    this.schoolType =
        EnumToString.fromString(SchoolType.values, schoolType ?? '');
    this.username = sharedPreferences.getString(this._usernameKey);
    this.encryptedPassword = sharedPreferences.getString(this._passwordKey);
    if (this.userType == null ||
        (this.userType == UserType.student && this.schoolType == null) ||
        (this.schoolType == SchoolType.vocationalGymnasium &&
            this.grade == null) ||
        this.username == null ||
        this.encryptedPassword == null) {
      return false;
    }
    return true;
  }

  void storeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        this._usertypeKey, EnumToString.convertToString(this.userType));
    if (this.schoolType != null)
      sharedPreferences.setString(
          this._schoolTypeKey, EnumToString.convertToString(this.schoolType));
    if (this.grade != null)
      sharedPreferences.setInt(this._gradeKey, this.grade!);
    sharedPreferences.setString(this._usernameKey, this.username!);
    sharedPreferences.setString(this._passwordKey, this.encryptedPassword!);
  }
}
