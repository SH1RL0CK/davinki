import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/subject_templates.dart';
import 'package:davinki/models/subject.dart';
import 'package:davinki/models/course.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/widgets/course_selector.dart';

class CourseSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  CourseSettingsScreen(
    this._infoserverData,
    this._generalSettings,
    this._courseSettings, {
    Key? key,
  }) : super(key: key);

  @override
  _CourseSettingsScreenState createState() => _CourseSettingsScreenState(
      this._infoserverData, this._generalSettings, this._courseSettings);
}

class _CourseSettingsScreenState extends State<CourseSettingsScreen> {
  final Map<String, dynamic> _infoserverData;
  final GeneralSettings _generalSettings;
  final CourseSettings _courseSettings;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Subject> _subjects = <Subject>[];

  _CourseSettingsScreenState(
      this._infoserverData, this._generalSettings, this._courseSettings) {
    this._createSubjectList();
  }

  /* 
    There could be diffrent courses with same title (for example Tutor) but with diffrent teachers.
    This the reason why this function searchs in the lessons for the course title and creates a list of the teachers for that
    course title.
  */
  List<String> _searchForCourseTeachersInLessons(String courseTitle) {
    List<String> teachers = <String>[];
    this
        ._infoserverData['result']['displaySchedule']['lessonTimes']
        .forEach((dynamic lessonAsMap) {
      if (!Lesson.isLesson(lessonAsMap)) return;
      Lesson lesson = Lesson.fromJson(lessonAsMap);
      if (lesson.course.title == courseTitle && !lesson.additional) {
        teachers.add(lesson.course.teacher);
      }
    });
    // This converts the list to a set and back to a list to remove the same teachers.
    return teachers.toSet().toList();
  }

  void _removeSubjectsWithNoCourses() {
    this._subjects = this
        ._subjects
        .where((Subject subject) => subject.courses.length > 0)
        .toList();
  }

  void _searchForSelectedCoursesInSettings() {
    this._subjects.forEach((Subject subject) {
      subject.courses.forEach((Course course) {
        if (this._courseSettings.usersCourses.contains(course))
          subject.usersCourse = course;
      });
    });
  }

  // Select a course automatically if this subject must be selected and there is only one course.
  void _autoSelectCoures() {
    this._subjects.forEach((Subject subject) {
      if ((subject.template.mustBeSelected ||
              subject.template.mustBeSelectedInGrades
                  .contains(this._generalSettings.grade)) &&
          subject.courses.length == 1 &&
          subject.usersCourse == null) {
        subject.usersCourse = subject.courses[0];
      }
    });
  }

  void _createSubjectList() {
    List<SubjectTemplate> templates =
        subjectTemplates[this._generalSettings.schoolType]!.where(
      (SubjectTemplate template) {
        return template.onlyInGrades == null ||
            template.onlyInGrades!.contains(this._generalSettings.grade);
      },
    ).toList();

    this._subjects = List<Subject>.generate(templates.length, (int index) {
      return Subject(templates[index]);
    });

    this._infoserverData['result']['subjects'].forEach((dynamic course) {
      String courseTitle = course['code'];
      SubjectTemplate? subjectTemplate = getSubjectTemplateByCourseTitle(
        courseTitle,
        schoolType: this._generalSettings.schoolType,
        grade: this._generalSettings.grade,
      );
      if (subjectTemplate == null) {
        return;
      }

      Subject subject = this
          ._subjects
          .firstWhere((Subject s) => s.template == subjectTemplate);

      List<String> teachers =
          this._searchForCourseTeachersInLessons(courseTitle);

      teachers.forEach((String teacher) {
        subject.courses.add(Course(courseTitle, teacher));
      });
    });
    this._removeSubjectsWithNoCourses();
    this._searchForSelectedCoursesInSettings();
    this._autoSelectCoures();
  }

  void _handleForm() {
    if (this._formKey.currentState!.validate()) {
      this._courseSettings.usersCourses.clear();
      this._subjects.forEach((Subject subject) {
        if (subject.usersCourse != null)
          this._courseSettings.usersCourses.add(subject.usersCourse!);
      });
      this._courseSettings.storeData();
      navigateToOtherScreen(
        LoadingScreen(),
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
              'Deine Kurse',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              'Bitte wähle Deine Kurse aus.',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: this._subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseSelector(
                    this._subjects[index], this._generalSettings);
              },
            ),
            SizedBox(height: 14),
            FloatingActionButton.extended(
              icon: Icon(Icons.save),
              label: Text(
                'Speichern',
              ),
              onPressed: this._handleForm,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
