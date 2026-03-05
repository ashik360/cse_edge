import 'package:cse_edge/features/subjects/domain/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    code: 'CSE 311',
    title: 'Database Management Systems',
    year: 3,
    semester: 1,
    units: [
      CourseUnit(title: 'Intro to SQL & ER Models', type: UnitType.note),
      CourseUnit(title: 'Relational Algebra Lectures', type: UnitType.video),
      CourseUnit(title: 'Normalization Practice Quiz', type: UnitType.quiz),
    ],
  ),
  Course(
    code: 'CSE 101',
    title: 'Structured Programming',
    year: 1,
    semester: 1,
    units: [
      CourseUnit(title: 'C Basics Chapter Note', type: UnitType.note),
      CourseUnit(title: 'Loop & Logic Tutorials', type: UnitType.video),
      CourseUnit(title: 'Function Drills Quiz', type: UnitType.quiz),
    ],
  ),
];