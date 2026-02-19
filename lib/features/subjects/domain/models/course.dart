enum UnitType { note, quiz, flashcard, video, mockTest }

class CourseUnit {
  const CourseUnit({
    required this.title,
    required this.type,
    this.locked = false,
    this.completed = false,
  });

  final String title;
  final UnitType type;
  final bool locked;
  final bool completed;
}

class Course {
  const Course({required this.code, required this.title, required this.units});

  final String code;
  final String title;
  final List<CourseUnit> units;

  int get completedUnits => units.where((unit) => unit.completed).length;
}
