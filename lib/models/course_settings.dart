import 'package:davinki/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseSettings {
  List<Course> usersCourses = <Course>[];
  String _courseTitlesKey = 'usersCourseTitles';
  String _teachersKeys = 'usersCourseTeachers';

  Future<bool> loadData() async {
    this.usersCourses.clear();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? courseTitles = sharedPreferences.getStringList(this._courseTitlesKey);
    List<String>? teachers = sharedPreferences.getStringList(this._teachersKeys);
    if (courseTitles == null || teachers == null) {
      return false;
    }
    for (int i = 0; i < courseTitles.length && i < teachers.length; i++) {
      this.usersCourses.add(Course(courseTitles[i], teachers[i]));
    }
    return true;
  }

  void storeData() async {
    List<String> courseTitles = <String>[];
    List<String> teachers = <String>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    this.usersCourses.forEach((Course course) {
      courseTitles.add(course.title);
      teachers.add(course.teacher);
    });
    sharedPreferences.setStringList(this._courseTitlesKey, courseTitles);
    sharedPreferences.setStringList(this._teachersKeys, teachers);
  }
}
