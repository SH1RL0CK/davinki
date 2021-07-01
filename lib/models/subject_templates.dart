import 'package:flutter/material.dart';
import 'package:davinki/models/school_type.dart';

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
    SubjectTemplate('Schwerpunkt-LK', Colors.blueAccent,
        <String>['PRIN', 'WIL', 'METR', 'ERWI'],
        mustBeSelected: true),
    SubjectTemplate('1. Schwerpunkt-GK', Colors.teal,
        <String>['ITEC', 'RWG', 'MTTS', 'PsyG'],
        mustBeSelected: true),
    SubjectTemplate(
        '2. Schwerpunkt-GK', Colors.cyan, <String>['PRING', 'DVG', 'ERWIG']),
    SubjectTemplate('Mathematik', Colors.blue.shade900, <String>['ML', 'MG'],
        mustBeSelected: true),
    SubjectTemplate('Englisch', Colors.yellow.shade800, <String>['EL', 'EG'],
        mustBeSelected: true),
    SubjectTemplate('Deutsch', Colors.red.shade600, <String>['DL', 'DG'],
        mustBeSelected: true),
    SubjectTemplate('Physik', Colors.grey.shade700, <String>['PhG']),
    SubjectTemplate('Biologie', Colors.green.shade800, <String>['BioG']),
    SubjectTemplate('Chemie', Colors.greenAccent.shade400, <String>['ChG']),
    SubjectTemplate(
        'Religion/Ethik', Colors.purple, <String>['ReG', 'RkG', 'EtG'],
        mustBeSelected: true),
    SubjectTemplate(
        'Politik & Wirtschaft', Colors.pink.shade700, <String>['PWG'],
        mustBeSelectedInGrades: [11, 12]),
    SubjectTemplate('Geschichte', Colors.black, <String>['GG'],
        mustBeSelected: true),
    SubjectTemplate('Sport', Colors.deepOrangeAccent, <String>['SpG'],
        mustBeSelected: true),
    SubjectTemplate(
        'Musik/Kunst/DSp', Colors.deepPurple, <String>['DSpG', 'MuK', 'KG'],
        onlyInGrades: <int>[13], mustBeSelected: true),
    SubjectTemplate('2. Fremdsprache', Colors.lime, <String>['SpanG', 'FG']),
    SubjectTemplate('Tutor', Colors.green, <String>['Tutor'],
        mustBeSelected: true),
  ],
};

SubjectTemplate? getSubjectTemplateByCourseTitle(String courseTitle,
    {SchoolType? schoolType, int? grade}) {
  SubjectTemplate? searchInSchoolType() {
    for (SubjectTemplate subjectTemplate in subjectTemplates[schoolType]!) {
      for (String courseTitlePrefix in subjectTemplate.courseTitlePrefixes) {
        RegExp regex = RegExp(r'^' + courseTitlePrefix + r'([0-9]+)?$');
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
      SubjectTemplate? result = searchInSchoolType();
      if (result != null) return result;
    }
  }
  return null;
}
