class Course {
  final String title, teacher;
  Course(this.title, this.teacher);

  int compareTo(Course otherCourse) {
    if (this.title != otherCourse.title) {
      return this.title.compareTo(otherCourse.title);
    }
    return this.teacher.compareTo(otherCourse.teacher);
  }

  @override
  bool operator ==(Object other) {
    return (other is Course) && other.title == this.title && other.teacher == this.teacher;
  }
}
