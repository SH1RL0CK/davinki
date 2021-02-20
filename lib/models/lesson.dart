class Lesson {
  final String course, teacher, room;
  final String newTeacher, newRoom;
  final bool cancelled, freeTime;
  final int color;
  bool currentLesson;

  Lesson({
    this.course = '',
    this.teacher = '',
    this.room = '',
    this.newTeacher = '',
    this.newRoom = '',
    this.cancelled = false,
    this.freeTime = false,
    this.color = 0,
    this.currentLesson = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> lesson, int color) {
    String teacher = '', room = '';
    String newTeacher = '', newRoom = '';
    bool cancelled = false;
    if (lesson.containsKey('teacherCodes')) {
      teacher = lesson['teacherCodes'][0];
    }
    if (lesson.containsKey('roomCodes')) {
      room = lesson['roomCodes'][0];
    }
    if (lesson.containsKey('changes')) {
      if (lesson['changes'].containsKey('newTeacherCodes')) {
        newTeacher = lesson['changes']['newTeacherCodes'][0];
      }
      if (lesson['changes'].containsKey('newRoomCodes')) {
        newRoom = lesson['changes']['newRoomCodes'][0];
      }
      if (lesson['changes']['caption'] == 'Klasse frei' || lesson['changes']['caption'] == 'Klasse fehlt') {
        cancelled = true;
      }
    }
    return Lesson(
      course: lesson['courseTitle'],
      teacher: teacher,
      room: room,
      newTeacher: newTeacher,
      newRoom: newRoom,
      cancelled: cancelled,
      color: color,
    );
  }
}
