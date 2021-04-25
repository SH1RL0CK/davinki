import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/utils.dart';
import 'package:davinki/models/course_settings.dart';
import 'package:davinki/models/course_group_templates.dart';
import 'package:davinki/models/course_group.dart';
import 'package:davinki/models/course.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';
import 'package:davinki/screens/setting_screens/couse_settings_screen/widgets/course_selector.dart';

class CourseSettingsScreen extends StatefulWidget {
  final CourseSettings _courseSettings;
  final Map<String, dynamic> _infoserverData;
  CourseSettingsScreen(this._courseSettings, this._infoserverData, {Key? key}) : super(key: key);

  @override
  _CourseSettingsScreenState createState() => _CourseSettingsScreenState(this._courseSettings, this._infoserverData);
}

class _CourseSettingsScreenState extends State<CourseSettingsScreen> {
  final CourseSettings _courseSettings;
  final Map<String, dynamic> _infoserverData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<int?> courses = List<int?>.filled(courseGroupTemplates.length, null);

  List<CourseGroup> _courseGroups = <CourseGroup>[];

  _CourseSettingsScreenState(this._courseSettings, this._infoserverData) : super() {
    this._createCourseGroupList();
  }

  void _createCourseGroupList() {
    this._courseGroups = List<CourseGroup>.generate(courseGroupTemplates.length, (int index) {
      return CourseGroup(courseGroupTemplates[index]);
    });

    this._infoserverData['result']['subjects'].forEach((dynamic course) {
      String courseTitle = course['code'];
      CourseGroupTemplate? groupTemplate = getGroupTemplateByCourseTitle(courseTitle);
      if (groupTemplate == null) {
        return;
      }
      List<String> teachers = <String>[];

      this._infoserverData['result']['displaySchedule']['lessonTimes'].forEach((dynamic lessonAsMap) {
        if (!Lesson.isLesson(lessonAsMap)) return;
        Lesson lesson = Lesson.fromJson(lessonAsMap);
        if (lesson.course.title == courseTitle && !lesson.additional) {
          teachers.add(lesson.course.teacher);
        }
      });
      CourseGroup group = this._courseGroups.firstWhere((CourseGroup group) => group.template == groupTemplate);
      teachers = teachers.toSet().toList();
      teachers.forEach((String teacher) {
        group.courses.add(Course(courseTitle, teacher));
      });
      this._courseGroups.forEach((CourseGroup group) {
        group.courses.forEach((Course course) {
          if (this._courseSettings.usersCourses.contains(course)) {
            group.usersCourse = course;
          }
        });
      });
    });
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
              itemCount: this._courseGroups.length,
              itemBuilder: (BuildContext context, int index) {
                return CourseSelector(this._courseGroups[index]);
              },
            ),
            SizedBox(height: 14),
            FloatingActionButton.extended(
              icon: Icon(Icons.save),
              label: Text(
                'Speichern',
              ),
              onPressed: () {
                if (this._formKey.currentState!.validate()) {
                  this._courseSettings.usersCourses.clear();
                  this._courseGroups.forEach((CourseGroup group) {
                    if (group.usersCourse != null) this._courseSettings.usersCourses.add(group.usersCourse!);
                  });
                  this._courseSettings.storeData();
                  navigateToOtherScreen(
                    LoadingScreen(),
                    context,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
