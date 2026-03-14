import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum UnitType { note, quiz, video, flashcard, mockTest, previousQuestion }

class UnitFileItem {
  const UnitFileItem({
    required this.title,
    required this.name,
    required this.url,
    required this.fileType,
    this.thumbnailUrl,
  });

  final String title;
  final String name;
  final String url;
  final String fileType; // pdf, image, doc, ppt, link
  final String? thumbnailUrl;

  factory UnitFileItem.fromMap(Map<String, dynamic> map) {
    return UnitFileItem(
      title: (map['title'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      url: (map['url'] as String?) ?? '',
      fileType: (map['fileType'] as String?) ?? 'file',
      thumbnailUrl: map['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'fileType': fileType,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class UnitVideoItem {
  const UnitVideoItem({
    required this.title,
    required this.url,
    this.author = '',
    this.duration = '',
    this.thumbnailUrl,
  });

  final String title;
  final String url;
  final String author;
  final String duration;
  final String? thumbnailUrl;

  factory UnitVideoItem.fromMap(Map<String, dynamic> map) {
    return UnitVideoItem(
      title: (map['title'] as String?) ?? '',
      url: (map['url'] as String?) ?? '',
      author: (map['author'] as String?) ?? '',
      duration: (map['duration'] as String?) ?? '',
      thumbnailUrl: map['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'url': url,
      'author': author,
      'duration': duration,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

class CourseUnit {
  const CourseUnit({
    required this.title,
    required this.type,
    this.locked = false,
    this.completed = false,
    this.files = const [],
    this.videos = const [],
  });

  final String title;
  final UnitType type;
  final bool locked;
  final bool completed;

  // for note / previousQuestion
  final List<UnitFileItem> files;

  // for video
  final List<UnitVideoItem> videos;

  factory CourseUnit.fromMap(Map<String, dynamic> map) {
  final rawFiles = (map['file'] as List?) ?? const [];
  final rawVideos = (map['videos'] as List?) ?? const [];

  return CourseUnit(
    title: (map['title'] as String?) ?? '',
    type: _unitTypeFromString((map['type'] as String?) ?? 'note'),
    locked: (map['locked'] as bool?) ?? false,
    completed: (map['completed'] as bool?) ?? false,
    files: rawFiles
        .whereType<Map>()
        .map((e) => UnitFileItem.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
    videos: rawVideos
        .whereType<Map>()
        .map((e) => UnitVideoItem.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
  );
}

Map<String, dynamic> toMap() {
  return {
    'title': title,
    'type': type.name,
    'locked': locked,
    'completed': completed,
    'file': files.map((e) => e.toMap()).toList(),
    'videos': videos.map((e) => e.toMap()).toList(),
  };
}

  static UnitType _unitTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'note':
        return UnitType.note;
      case 'quiz':
        return UnitType.quiz;
      case 'video':
        return UnitType.video;
      case 'flashcard':
        return UnitType.flashcard;
      case 'mocktest':
        return UnitType.mockTest;
      case 'previousquestion':
        return UnitType.previousQuestion;
      case 'previous_question':
        return UnitType.previousQuestion;
      default:
        return UnitType.note;
    }
  }
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

  String get semesterFullLabel {
    String yearSuffix =
        year == 1
            ? 'st'
            : year == 2
            ? 'nd'
            : year == 3
            ? 'rd'
            : 'th';
    String semSuffix = semester == 1 ? 'st' : 'nd';
    return '$year$yearSuffix Year, $semester$semSuffix Sem';
  }

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final rawUnits = (data['units'] as List?) ?? const [];
    final units = rawUnits
        .whereType<Map>()
        .map((unit) => CourseUnit.fromMap(Map<String, dynamic>.from(unit)))
        .toList();

    return Course(
      code: (data['code'] as String?) ?? doc.id,
      title: (data['title'] as String?) ?? '',
      year: (data['year'] as num?)?.toInt() ?? 1,
      semester: (data['semester'] as num?)?.toInt() ?? 1,
      units: units,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'title': title,
      'year': year,
      'semester': semester,
      'units': units.map((unit) => unit.toMap()).toList(),
    };
  }
}