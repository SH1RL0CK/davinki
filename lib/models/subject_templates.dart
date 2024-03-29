import 'package:davinki/models/school_type.dart';
import 'package:flutter/material.dart';

class SubjectTemplate {
  final String title;
  final Color color;
  final List<String> courseTitlePrefixes;
  final List<int>? onlyInGrades;
  final bool mustBeSelected;
  final List<int> mustBeSelectedInGrades;
  SubjectTemplate(
    this.title,
    this.color,
    this.courseTitlePrefixes, {
    this.onlyInGrades,
    this.mustBeSelected = false,
    this.mustBeSelectedInGrades = const <int>[],
  });
}

Map<SchoolType, List<SubjectTemplate>> subjectTemplates =
    <SchoolType, List<SubjectTemplate>>{
  SchoolType.vocationalGymnasium: <SubjectTemplate>[
    SubjectTemplate(
      'Schwerpunkt-LK',
      Colors.blueAccent,
      <String>['PRINL', 'WIL', 'METRL', 'ERWIL'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      '1. Schwerpunkt-GK',
      Colors.teal,
      <String>['ITECG', 'RWG', 'MTTSG', 'PsyG'],
      mustBeSelectedInGrades: <int>[11, 12],
    ),
    SubjectTemplate(
      '2. Schwerpunkt-GK',
      Colors.cyan,
      <String>['PRING', 'DVG', 'ERWIG'],
    ),
    SubjectTemplate(
      '3. Schwerpunkt-GK',
      Colors.cyan.shade200,
      <String>['WIG'],
    ),
    SubjectTemplate(
      'Mathematik',
      Colors.blue.shade900,
      <String>['ML', 'MG'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      'Englisch',
      Colors.yellow.shade800,
      <String>['EL', 'EG'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      'Deutsch',
      Colors.red.shade600,
      <String>['DL', 'DG'],
      mustBeSelected: true,
    ),
    SubjectTemplate('Physik', Colors.grey.shade700, <String>['PhG']),
    SubjectTemplate('Biologie', Colors.green.shade800, <String>['BioG']),
    SubjectTemplate('Chemie', Colors.greenAccent.shade400, <String>['ChG']),
    SubjectTemplate(
      'Religion/Ethik',
      Colors.purple,
      <String>['ReG', 'RkG', 'EtG'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      'Politik & Wirtschaft',
      Colors.pink.shade700,
      <String>['PWG'],
      mustBeSelectedInGrades: <int>[11, 12],
    ),
    SubjectTemplate(
      'Geschichte',
      Colors.black,
      <String>['GG'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      'Sport',
      Colors.deepOrangeAccent,
      <String>['SpG'],
      mustBeSelected: true,
    ),
    SubjectTemplate(
      'Musik/Kunst/DSp',
      Colors.deepPurple,
      <String>['DSpG', 'MuG', 'KG'],
      onlyInGrades: <int>[13],
      mustBeSelected: true,
    ),
    SubjectTemplate('2. Fremdsprache', Colors.lime, <String>['SpanG', 'FG']),
    SubjectTemplate(
      'Tutor',
      Colors.green,
      <String>['Tutor'],
      mustBeSelected: true,
    ),
  ],
};

SubjectTemplate? getSubjectTemplateByCourseTitle(
  String courseTitle, {
  SchoolType? schoolType,
  int? grade,
}) {
  SubjectTemplate? searchInSchoolType() {
    for (final SubjectTemplate subjectTemplate
        in subjectTemplates[schoolType]!) {
      for (final String courseTitlePrefix
          in subjectTemplate.courseTitlePrefixes) {
        // ignore: unnecessary_raw_strings
        final RegExp regex = RegExp(r'^' + courseTitlePrefix + r'([0-9]+)?$');
        if (regex.hasMatch(courseTitle) &&
            (grade == null ||
                (subjectTemplate.onlyInGrades == null ||
                    subjectTemplate.onlyInGrades!.contains(grade)))) {
          return subjectTemplate;
        }
      }
    }
    return null;
  }

  if (schoolType != null) {
    return searchInSchoolType();
  } else {
    for (schoolType in subjectTemplates.keys) {
      final SubjectTemplate? result = searchInSchoolType();
      if (result != null) return result;
    }
  }
  return null;
}
