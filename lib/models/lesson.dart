class Lesson {
  final String course, teacher, room;
  final String date, sartTime;
  final String changeCaption, changeInformation;
  final String newTeacher, newRoom;
  final bool cancelled, additional, freeTime;
  final int color;
  bool currentLesson;

  Lesson({
    this.course = '',
    this.teacher = '',
    this.room = '',
    this.date = '',
    this.sartTime = '',
    this.changeCaption = '',
    this.changeInformation,
    this.newTeacher = '',
    this.newRoom = '',
    this.freeTime = false,
    this.cancelled = false,
    this.additional = false,
    this.color = 0,
    this.currentLesson = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> lesson, String date, int color) {
    String teacher = '', room = '';
    String changeCaption = '', changeInformation = '';
    String newTeacher = '', newRoom = '';
    bool cancelled = false, additional = false;
    if (lesson.containsKey('teacherCodes')) {
      teacher = lesson['teacherCodes'][0];
    }
    if (lesson.containsKey('roomCodes')) {
      room = lesson['roomCodes'][0];
    }
    if (lesson.containsKey('changes')) {
      changeCaption = lesson['changes']['caption'];
      if (lesson['changes'].containsKey('information')) {
        changeInformation = lesson['changes']['information'];
      }
      if (lesson['changes'].containsKey('newTeacherCodes')) {
        newTeacher = lesson['changes']['newTeacherCodes'][0];
      }
      if (lesson['changes'].containsKey('newRoomCodes')) {
        newRoom = lesson['changes']['newRoomCodes'][0];
      }
      if (changeCaption == 'Klasse frei' || changeCaption == 'Klasse fehlt') {
        cancelled = true;
      }
      if (changeCaption == 'Zusatzunterricht') {
        additional = true;
      }
    }
    return Lesson(
      course: lesson['courseTitle'],
      teacher: teacher,
      changeCaption: changeCaption,
      changeInformation: changeInformation,
      room: room,
      date: date,
      sartTime: lesson['startTime'],
      newTeacher: newTeacher,
      newRoom: newRoom,
      cancelled: cancelled,
      additional: additional,
      color: color,
    );
  }
}
