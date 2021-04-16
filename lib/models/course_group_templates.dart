import 'package:flutter/material.dart';

class CourseGroupTemplate {
  final String describtion;
  final Color color;
  final List<String> courseTitlePrefixes;
  final bool mustBeSelected;
  CourseGroupTemplate(this.describtion, this.color, this.courseTitlePrefixes, {this.mustBeSelected = false});
}

List<CourseGroupTemplate> courseGroupTemplates = <CourseGroupTemplate>[
  CourseGroupTemplate('Schwerpunkt-LK', Colors.blueAccent, <String>['PRIN', 'WIL', 'METR', 'ERWI'], mustBeSelected: true),
  CourseGroupTemplate('1. Schwerpunkt-GK', Colors.teal, <String>['ITEC', 'RWG', 'MTTS', 'PsyG'], mustBeSelected: true),
  CourseGroupTemplate('2. Schwerpunkt-GK', Colors.cyan, <String>['PRING', 'DVG', 'ERWIG'], mustBeSelected: true),
  CourseGroupTemplate('Mathematik', Colors.blue.shade900, <String>['ML', 'MG'], mustBeSelected: true),
  CourseGroupTemplate('Englisch', Colors.yellow.shade800, <String>['EL', 'EG'], mustBeSelected: true),
  CourseGroupTemplate('Deutsch', Colors.red, <String>['DL', 'DG'], mustBeSelected: true),
  CourseGroupTemplate('Physik', Colors.grey.shade700, <String>['PhG']),
  CourseGroupTemplate('Biologie', Colors.grey.shade700, <String>['BioG']),
  CourseGroupTemplate('Chemie', Colors.grey.shade700, <String>['ChG']),
  CourseGroupTemplate('Religion/Ethik', Colors.purple, <String>['ReG', 'RkG', 'EtG'], mustBeSelected: true),
  CourseGroupTemplate('Politik & Wirtschaft', Colors.pink, <String>['PWG']),
  CourseGroupTemplate('Geschichte', Colors.black, <String>['GG'], mustBeSelected: true),
  CourseGroupTemplate('Sport', Colors.deepOrangeAccent, <String>['SpG'], mustBeSelected: true),
  CourseGroupTemplate('2. Fremdsprache', Colors.lime, <String>['SpanG', 'FG']),
  CourseGroupTemplate('Turtor', Colors.green, <String>['Tutor'], mustBeSelected: true),
];

CourseGroupTemplate? getGroupTemplateByCourseTitle(String courseTitle) {
  for (CourseGroupTemplate groupTemplate in courseGroupTemplates) {
    for (String courseTitlePrefix in groupTemplate.courseTitlePrefixes) {
      RegExp regex = RegExp(courseTitlePrefix + r'([0-9]+)?$');
      if (regex.hasMatch(courseTitle)) {
        return groupTemplate;
      }
    }
  }
  return null;
}
