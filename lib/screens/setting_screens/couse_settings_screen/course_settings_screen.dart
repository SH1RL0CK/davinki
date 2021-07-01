import 'package:davinki/models/course.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/models/subject.dart';
import 'package:davinki/models/subject_templates.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/widgets/course_selector.dart';
import 'package:davinki/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  const CourseSettingsScreen(
    this._infoserverData,
    this._generalSettings,
    this._courseSettings, {
    Key? key,
  }) : super(key: key);

  @override
  _CourseSettingsScreenState createState() => _CourseSettingsScreenState(
        _infoserverData,
        _generalSettings,
        _courseSettings,
      );
}

class _CourseSettingsScreenState extends State<CourseSettingsScreen> {
  final Map<String, dynamic> _infoserverData;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Subject> _subjects = <Subject>[];

  _CourseSettingsScreenState(
      this._infoserverData, this._generalSettings, this._courseSettings) {
    _createSubjectList();
  }

  /* 
    There could be diffrent courses with same title (for example Tutor) but with diffrent teachers.
    This the reason why this function searchs in the lessons for the course title and creates a list of the teachers for that
    course title.
  */
  List<String> _searchForCourseTeachersInLessons(String courseTitle) {
    final List<String> teachers = <String>[];
    _infoserverData['result']['displaySchedule']['lessonTimes']
        .forEach((dynamic lessonAsMap) {
      if (!Lesson.isLesson(lessonAsMap as Map<String, dynamic>)) return;
      final Lesson lesson = Lesson.fromJson(lessonAsMap);
      if (lesson.course.title == courseTitle && !lesson.additional) {
        teachers.add(lesson.course.teacher);
      }
    });
    // This converts the list to a set and back to a list to remove the same teachers.
    return teachers.toSet().toList();
  }

  void _removeSubjectsWithNoCourses() {
    _subjects = _subjects
        .where((Subject subject) => subject.courses.isNotEmpty)
        .toList();
  }

  void _searchForSelectedCoursesInSettings() {
    for (final Subject subject in _subjects) {
      for (final Course course in subject.courses) {
        if (_courseSettings.usersCourses.contains(course)) {
          subject.usersCourse = course;
        }
      }
    }
  }

  // Select a course automatically if this subject must be selected and there is only one course.
  void _autoSelectCoures() {
    for (final Subject subject in _subjects) {
      if ((subject.template.mustBeSelected ||
              subject.template.mustBeSelectedInGrades
                  .contains(_generalSettings.grade)) &&
          subject.courses.length == 1 &&
          subject.usersCourse == null) {
        subject.usersCourse = subject.courses[0];
      }
    }
  }

  void _createSubjectList() {
    final List<SubjectTemplate> templates =
        subjectTemplates[_generalSettings.schoolType]!.where(
      (SubjectTemplate template) {
        return template.onlyInGrades == null ||
            template.onlyInGrades!.contains(_generalSettings.grade);
      },
    ).toList();

    _subjects = List<Subject>.generate(templates.length, (int index) {
      return Subject(templates[index]);
    });

    _infoserverData['result']['subjects'].forEach((dynamic course) {
      final String courseTitle = course['code'].toString();
      final SubjectTemplate? subjectTemplate = getSubjectTemplateByCourseTitle(
        courseTitle,
        schoolType: _generalSettings.schoolType,
        grade: _generalSettings.grade,
      );
      if (subjectTemplate == null) {
        return;
      }

      final Subject subject =
          _subjects.firstWhere((Subject s) => s.template == subjectTemplate);

      final List<String> teachers =
          _searchForCourseTeachersInLessons(courseTitle);

      for (final String teacher in teachers) {
        subject.courses.add(Course(courseTitle, teacher));
      }
    });
    _removeSubjectsWithNoCourses();
    _searchForSelectedCoursesInSettings();
    _autoSelectCoures();
  }

  void _handleForm() {
    if (_formKey.currentState!.validate()) {
      _courseSettings.usersCourses.clear();
      for (final Subject subject in _subjects) {
        if (subject.usersCourse != null) {
          _courseSettings.usersCourses.add(subject.usersCourse!);
        }
      }
      _courseSettings.storeData();
      navigateToOtherScreen(
        const LoadingScreen(),
        context,
      );
    }
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
              navigateToOtherScreen(
                const LoadingScreen(),
                context,
              );
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12.0),
          children: <Widget>[
            const Text(
              'Deine Kurse',
              style: TextStyle(fontSize: 25),
            ),
            const Text(
              'Wähle bitte Deine Kurse aus.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: _subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseSelector(_subjects[index], _generalSettings);
              },
            ),
            const SizedBox(height: 14),
            FloatingActionButton.extended(
              icon: const Icon(Icons.save),
              label: const Text(
                'Speichern',
              ),
              onPressed: _handleForm,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
