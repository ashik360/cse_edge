import 'package:flutter/material.dart';

enum UnitType { note, quiz, video, flashcard, mockTest, previousQuestion }

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

class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation = '',
  });

  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
}

class Course {
  const Course({
    required this.code,
    required this.title,
    required this.units,
    required this.year,
    required this.semester,
  });

  final String code;
  final String title;
  final List<CourseUnit> units;
  final int year;
  final int semester;

  int get completedUnits => units.where((unit) => unit.completed).length;

  // Helper for UI display: "3rd Year, 1st Sem"
  String get semesterFullLabel {
    String yearSuffix = year == 1 ? 'st' : year == 2 ? 'nd' : year == 3 ? 'rd' : 'th';
    String semSuffix = semester == 1 ? 'st' : 'nd';
    return '$year$yearSuffix Year, $semester$semSuffix Sem';
  }
}