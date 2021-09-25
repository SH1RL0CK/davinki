class Course {
  final String title;
  final String teacher;
  Course(this.title, this.teacher);

  int compareTo(Course otherCourse) {
    if (title != otherCourse.title) {
      return title.compareTo(otherCourse.title);
    }
    return teacher.compareTo(otherCourse.teacher);
  }

  @override
  bool operator ==(Object other) {
    return (other is Course) &&
        other.title == title &&
        other.teacher == teacher;
  }

  @override
  int get hashCode => title.hashCode ^ teacher.hashCode;
}
