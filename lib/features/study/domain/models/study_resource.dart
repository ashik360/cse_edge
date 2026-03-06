import 'package:cloud_firestore/cloud_firestore.dart';
class ResourceRequest {
  const ResourceRequest({
    required this.id,
    required this.title,
    required this.authorName,
    required this.createdAtLabel,
    required this.replyCount,
  });

  final String id;
  final String title;
  final String authorName;
  final String createdAtLabel;
  final int replyCount;
}



class StudyResource {
  final String id;
  final String title;
  final String subjectCode;
  final String category; // 'Notes', 'PYQ', 'Quiz'
  final int year;
  final int semester;
  final String fileUrl; // URL to the PDF or Link
  final String authorName;
  final DateTime createdAt;

  StudyResource({
    required this.id,
    required this.title,
    required this.subjectCode,
    required this.category,
    required this.year,
    required this.semester,
    required this.fileUrl,
    required this.authorName,
    required this.createdAt,
  });

  factory StudyResource.fromJson(Map<String, dynamic> json, String id) {
    return StudyResource(
      id: id,
      title: json['title'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      category: json['category'] ?? 'Notes',
      year: json['year'] ?? 1,
      semester: json['semester'] ?? 1,
      fileUrl: json['fileUrl'] ?? '',
      authorName: json['authorName'] ?? 'Anonymous',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subjectCode': subjectCode,
      'category': category,
      'year': year,
      'semester': semester,
      'fileUrl': fileUrl,
      'authorName': authorName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}