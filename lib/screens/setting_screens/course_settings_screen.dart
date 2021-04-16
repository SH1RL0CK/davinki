import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:davinki/models/course_group_templates.dart';
import 'package:davinki/models/course_group.dart';
import 'package:davinki/models/course.dart';
import 'package:davinki/models/lesson.dart';
import 'package:davinki/screens/loading_screen/loading_screen.dart';

class CourseSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> _infoserverData;
  CourseSettingsScreen(this._infoserverData, {Key? key}) : super(key: key);

  @override
  _CourseSettingsScreenState createState() => _CourseSettingsScreenState(this._infoserverData);
}

class _CourseSettingsScreenState extends State<CourseSettingsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _infoserverData;

  List<int?> courses = List<int?>.filled(courseGroupTemplates.length, null);

  List<CourseGroup> _courseGroups = <CourseGroup>[];

  _CourseSettingsScreenState(this._infoserverData) : super() {
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
        Lesson lesson = Lesson.fromJson(lessonAsMap, DateTime(0), 0);
        if (lesson.course == courseTitle) {
          teachers.add(lesson.teacher);
        }
      });
      CourseGroup group = this._courseGroups.firstWhere((CourseGroup group) => group.template == groupTemplate);
      teachers = teachers.toSet().toList();
      teachers.forEach((String teacher) {
        group.courses.add(Course(courseTitle, teacher));
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen()),
                (Route route) => false,
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
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: this._courseGroups.length,
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this._courseGroups[i].template.describtion,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      DropdownButtonFormField<Course>(
                          value: this._courseGroups[i].usersCourse,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red.shade900, width: 3.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: this._courseGroups[i].template.color, width: 2.0),
                            ),
                            hintText: 'Nicht ausgewählt',
                          ),
                          validator: (Course? course) {
                            if (this._courseGroups[i].template.mustBeSelected && course == null) {
                              return 'Dieser Kurs muss ausgewählt werden!';
                            }
                            return null;
                          },
                          onChanged: (Course? newCourse) {
                            setState(() {
                              this._courseGroups[i].usersCourse = newCourse;
                            });
                          },
                          items: <DropdownMenuItem<Course>>[
                                DropdownMenuItem<Course>(
                                  child: Text('Nicht auswgewählt'),
                                  value: null,
                                )
                              ] +
                              List<DropdownMenuItem<Course>>.generate(this._courseGroups[i].courses.length, (int j) {
                                return DropdownMenuItem<Course>(
                                  child: Text('${this._courseGroups[i].courses[j].title}  (Lehrer/in: ${this._courseGroups[i].courses[j].teacher})'),
                                  value: this._courseGroups[i].courses[j],
                                );
                              })),
                    ],
                  ),
                );
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
                  print(true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
