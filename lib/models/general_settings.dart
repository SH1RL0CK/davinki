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

  final String _usertypeKey = 'userType';
  final String _schoolTypeKey = 'schoolType';
  final String _gradeKey = 'grade';
  final String _usernameKey = 'username';
  final String _passwordKey = 'password';

  Future<bool> loadData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String? storedUserType = sharedPreferences.getString(_usertypeKey);
    userType = EnumToString.fromString<UserType>(
      UserType.values,
      storedUserType ?? '',
    );
    final String? storedSchoolType =
        sharedPreferences.getString(_schoolTypeKey);
    schoolType = EnumToString.fromString<SchoolType>(
      SchoolType.values,
      storedSchoolType ?? '',
    );
    grade = sharedPreferences.getInt(_gradeKey);
    username = sharedPreferences.getString(_usernameKey);
    encryptedPassword = sharedPreferences.getString(_passwordKey);
    if (userType == null ||
        (userType == UserType.student && schoolType == null) ||
        (schoolType == SchoolType.vocationalGymnasium && grade == null) ||
        username == null ||
        encryptedPassword == null) {
      return false;
    }
    return true;
  }

  Future<void> storeData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(
        _usertypeKey, EnumToString.convertToString(userType));
    if (schoolType != null) {
      sharedPreferences.setString(
        _schoolTypeKey,
        EnumToString.convertToString(schoolType),
      );
    }
    if (grade != null) {
      sharedPreferences.setInt(_gradeKey, grade!);
    }
    sharedPreferences.setString(_usernameKey, username!);
    sharedPreferences.setString(_passwordKey, encryptedPassword!);
  }
}
