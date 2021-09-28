import 'package:davinki/models/course.dart';
import 'package:davinki/models/subject_templates.dart';

class Subject {
  List<Course> courses = <Course>[];
  Course? usersCourse;
  final SubjectTemplate template;
  Subject(this.template);
}
