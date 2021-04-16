class Course {
  final String title, teacher;
  Course(this.title, this.teacher);
  @override
  bool operator ==(Object other) {
    return (other is Course) && other.title == this.title && other.teacher == this.teacher;
  }
}
