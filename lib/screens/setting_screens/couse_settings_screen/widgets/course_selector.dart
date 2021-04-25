import 'package:flutter/material.dart';
import 'package:davinki/models/course_group.dart';
import 'package:davinki/models/general_settings.dart';
import 'package:davinki/models/course.dart';

class CourseSelector extends StatefulWidget {
  final CourseGroup _courseGroup;
  final GeneralSettings _generalSettings;
  CourseSelector(this._courseGroup, this._generalSettings, {Key? key}) : super(key: key);

  @override
  _CourseSelectorState createState() => _CourseSelectorState(this._courseGroup, this._generalSettings);
}

class _CourseSelectorState extends State<CourseSelector> {
  final CourseGroup _courseGroup;
  final GeneralSettings _generalSettings;

  _CourseSelectorState(this._courseGroup, this._generalSettings);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this._courseGroup.template.describtion,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 5,
          ),
          DropdownButtonFormField<Course>(
            value: this._courseGroup.usersCourse,
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: this._courseGroup.template.color, width: 3.0),
              ),
              hintText: 'Nicht ausgewählt',
            ),
            validator: (Course? course) {
              if ((this._courseGroup.template.mustBeSelected ||
                      this._courseGroup.template.mustBeSelectedInGrade.contains(this._generalSettings.grade)) &&
                  course == null) {
                return 'Dieser Kurs muss ausgewählt werden!';
              }
              return null;
            },
            onChanged: (Course? newCourse) {
              setState(() {
                this._courseGroup.usersCourse = newCourse;
              });
            },
            items: <DropdownMenuItem<Course>>[
                  DropdownMenuItem<Course>(
                    child: Text('Nicht auswgewählt'),
                    value: null,
                  )
                ] +
                List<DropdownMenuItem<Course>>.generate(
                  this._courseGroup.courses.length,
                  (int index) {
                    return DropdownMenuItem<Course>(
                      child: Text(
                        '${this._courseGroup.courses[index].title} (Lehrer/in: ${this._courseGroup.courses[index].teacher})',
                        style: TextStyle(
                            fontWeight: this._courseGroup.courses[index] == this._courseGroup.usersCourse ? FontWeight.bold : FontWeight.normal),
                      ),
                      value: this._courseGroup.courses[index],
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
