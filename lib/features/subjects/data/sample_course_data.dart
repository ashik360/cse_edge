import 'package:cse_edge/features/subjects/domain/models/course.dart';

const List<Course> sampleCourses = [
  Course(
    code: 'CSE 101',
    title: 'Structured Programming',
    semester: 1,
    units: [
      CourseUnit(
        title: 'C Basics and Program Structure',
        type: UnitType.note,
        completed: true,
      ),
      CourseUnit(
        title: 'Conditional Logic and Loops',
        type: UnitType.flashcard,
      ),
      CourseUnit(
        title: 'Array, String, and Pointer Fundamentals',
        type: UnitType.video,
      ),
      CourseUnit(
        title: 'Function and Recursion Practice Quiz',
        type: UnitType.quiz,
      ),
      CourseUnit(title: 'Chapter Mock Test', type: UnitType.mockTest),
    ],
  ),
  Course(
    code: 'MAT 101',
    title: 'Differential and Integral Calculus',
    semester: 1,
    units: [
      CourseUnit(
        title: 'Limits and Continuity Essentials',
        type: UnitType.note,
        completed: true,
      ),
      CourseUnit(
        title: 'Differentiation Formula Sheet',
        type: UnitType.flashcard,
      ),
      CourseUnit(
        title: 'Integration Shortcuts',
        type: UnitType.video,
        locked: true,
      ),
      CourseUnit(
        title: 'Exam-Style MCQ Set',
        type: UnitType.quiz,
        locked: true,
      ),
      CourseUnit(
        title: 'Night-Before Drill',
        type: UnitType.mockTest,
        locked: true,
      ),
    ],
  ),
  Course(
    code: 'EEE 101',
    title: 'Basic Electrical Engineering',
    semester: 1,
    units: [
      CourseUnit(title: 'Ohm and Kirchhoff Quick Notes', type: UnitType.note),
      CourseUnit(title: 'AC/DC Circuit Problem Set', type: UnitType.quiz),
      CourseUnit(
        title: 'Machine and Transformer Revision',
        type: UnitType.flashcard,
      ),
      CourseUnit(title: 'Final Minute Formula Sheet', type: UnitType.note),
      CourseUnit(title: 'Sectional Mock Test', type: UnitType.mockTest),
    ],
  ),
  // Semester 2
  Course(
    code: 'CSE 201',
    title: 'Data Structures',
    semester: 2,
    units: [
      CourseUnit(title: 'Introduction to Data Structures', type: UnitType.note),
      CourseUnit(title: 'Arrays and Linked Lists', type: UnitType.note),
    ],
  ),
  Course(
    code: 'MAT 201',
    title: 'Linear Algebra',
    semester: 2,
    units: [
      CourseUnit(title: 'Vectors and Matrices', type: UnitType.note),
    ],
  ),
  // Semester 3
  Course(
    code: 'CSE 301',
    title: 'Algorithms',
    semester: 3,
    units: [
      CourseUnit(title: 'Algorithm Analysis', type: UnitType.note),
      CourseUnit(title: 'Sorting and Searching', type: UnitType.note),
    ],
  ),
  Course(
    code: 'CSE 303',
    title: 'Database Management',
    semester: 3,
    units: [
      CourseUnit(title: 'Introduction to SQL', type: UnitType.note),
    ],
  ),
];
