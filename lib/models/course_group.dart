import 'package:davinki/models/course.dart';
import 'package:davinki/models/course_group_templates.dart';

class CourseGroup {
  List<Course> courses = <Course>[];
  Course? usersCourse;
  final CourseGroupTemplate template;
  CourseGroup(this.template);
}
