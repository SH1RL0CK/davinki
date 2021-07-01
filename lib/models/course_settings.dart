import 'package:davinki/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseSettings {
  List<Course> usersCourses = <Course>[];
  final String _courseTitlesKey = 'usersCourseTitles';
  final String _teachersKeys = 'usersCourseTeachers';

  Future<bool> loadData() async {
    usersCourses.clear();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final List<String>? courseTitles =
        sharedPreferences.getStringList(_courseTitlesKey);
    final List<String>? teachers =
        sharedPreferences.getStringList(_teachersKeys);
    if (courseTitles == null || teachers == null) {
      return false;
    }
    for (int i = 0; i < courseTitles.length && i < teachers.length; i++) {
      usersCourses.add(Course(courseTitles[i], teachers[i]));
    }
    return true;
  }

  Future<void> storeData() async {
    final List<String> courseTitles = <String>[];
    final List<String> teachers = <String>[];
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    for (final Course course in usersCourses) {
      courseTitles.add(course.title);
      teachers.add(course.teacher);
    }
    sharedPreferences.setStringList(_courseTitlesKey, courseTitles);
    sharedPreferences.setStringList(_teachersKeys, teachers);
  }
}
