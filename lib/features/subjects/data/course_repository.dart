import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/subjects/data/sample_course_data.dart';
import 'package:cse_edge/features/subjects/domain/models/course.dart';

class CourseRepository {
  CourseRepository({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;

  Stream<List<Course>> watchCourses({
    required int year,
    required int semester,
  }) {
    if (!FirebaseBootstrap.isAvailable) {
      final fallback =
          sampleCourses
              .where((c) => c.year == year && c.semester == semester)
              .toList();
      return Stream.value(fallback);
    }

    return firestore
        .collection('courses')
        .where('year', isEqualTo: year)
        .where('semester', isEqualTo: semester)
        .snapshots()
        .map((snapshot) {
          final courses =
              snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList();

          if (courses.isEmpty) {
            return sampleCourses
                .where((c) => c.year == year && c.semester == semester)
                .toList();
          }

          return courses;
        });
  }
}