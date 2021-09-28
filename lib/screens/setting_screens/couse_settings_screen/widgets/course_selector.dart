import 'package:davinki/models/course.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/subject.dart';
import 'package:flutter/material.dart';

class CourseSelector extends StatefulWidget {
  final Subject subject;
  final GeneralSettings _generalSettings;
  const CourseSelector(this.subject, this._generalSettings, {Key? key})
      : super(key: key);

  @override
  _CourseSelectorState createState() =>
      _CourseSelectorState(subject, _generalSettings);
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
            _subject.template.title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownButtonFormField<Course>(
            value: _subject.usersCourse,
            decoration: InputDecoration(
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: _subject.template.color, width: 3.0),
              ),
            ),
            validator: (Course? course) {
              if ((_subject.template.mustBeSelected ||
                      _subject.template.mustBeSelectedInGrades
                          .contains(_generalSettings.grade)) &&
                  course == null) {
                return 'Dieser Kurs muss ausgewählt werden!';
              }
              return null;
            },
            onChanged: (Course? newCourse) {
              setState(() {
                _subject.usersCourse = newCourse;
              });
            },
            selectedItemBuilder: (BuildContext context) =>
                <Text>[
                  const Text(
                    'Nicht auswgewählt',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ] +
                _subject.courses
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
                        fontWeight: _subject.usersCourse == null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  )
                ] +
                _subject.courses
                    .map<DropdownMenuItem<Course>>(
                      (Course course) => DropdownMenuItem<Course>(
                        value: course,
                        child: Text(
                          '${course.title} (Lehrer/in: ${course.teacher})',
                          style: TextStyle(
                            fontWeight: _subject.usersCourse == course
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          )
        ],
      ),
    );
  }
}
