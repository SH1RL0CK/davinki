import 'package:flutter/material.dart';
import 'package:davinki/models/subject.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/course.dart';

class CourseSelector extends StatefulWidget {
  final Subject subject;
  final GeneralSettings _generalSettings;
  CourseSelector(this.subject, this._generalSettings, {Key? key})
      : super(key: key);

  @override
  _CourseSelectorState createState() =>
      _CourseSelectorState(this.subject, this._generalSettings);
}

class _CourseSelectorState extends State<CourseSelector> {
  final Subject _subject;
  final GeneralSettings _generalSettings;

  _CourseSelectorState(this._subject, this._generalSettings);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this._subject.template.title,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 5,
          ),
          DropdownButtonFormField<Course>(
            value: this._subject.usersCourse,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: this._subject.template.color, width: 3.0),
              ),
            ),
            validator: (Course? course) {
              if ((this._subject.template.mustBeSelected ||
                      this
                          ._subject
                          .template
                          .mustBeSelectedInGrades
                          .contains(this._generalSettings.grade)) &&
                  course == null) {
                return 'Dieser Kurs muss ausgewählt werden!';
              }
              return null;
            },
            onChanged: (Course? newCourse) {
              setState(() {
                this._subject.usersCourse = newCourse;
              });
            },
            selectedItemBuilder: (BuildContext context) =>
                <Text>[
                  Text(
                    'Nicht auswgewählt',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ] +
                this
                    ._subject
                    .courses
                    .map<Text>(
                      (Course course) => Text(
                        '${course.title} (Lehrer/in: ${course.teacher})',
                      ),
                    )
                    .toList(),
            items: <DropdownMenuItem<Course>>[
                  DropdownMenuItem<Course>(
                    child: Text(
                      'Nicht auswgewählt',
                      style: TextStyle(
                        fontWeight: this._subject.usersCourse == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    value: null,
                  )
                ] +
                this
                    ._subject
                    .courses
                    .map<DropdownMenuItem<Course>>(
                      (Course course) => DropdownMenuItem<Course>(
                        child: Text(
                          '${course.title} (Lehrer/in: ${course.teacher})',
                          style: TextStyle(
                            fontWeight: this._subject.usersCourse == course
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        value: course,
                      ),
                    )
                    .toList(),
          )
        ],
      ),
    );
  }
}
