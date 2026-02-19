import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/study/domain/models/resource_request.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudyCloudService {
  StudyCloudService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore,
      _auth = auth;

  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;

  FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;
  FirebaseAuth get auth => _auth ?? FirebaseAuth.instance;

  Stream<List<ResourceRequest>> watchResourceRequests() {
    if (!FirebaseBootstrap.isAvailable) {
      return Stream.value(const [
        ResourceRequest(
          id: 'demo-1',
          title: 'Need MAT 101 Integration Class Slides',
          authorName: 'Sadia',
          createdAtLabel: 'just now',
          replyCount: 3,
        ),
        ResourceRequest(
          id: 'demo-2',
          title: 'Anyone has CSE 101 Pointer Cheat Sheet?',
          authorName: 'Rabbi',
          createdAtLabel: 'just now',
          replyCount: 2,
        ),
      ]);
    }

    return firestore
        .collection('resource_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final replies = (data['replyCount'] as num?)?.toInt() ?? 0;
            final title = (data['title'] as String?) ?? '';
            final author = (data['authorName'] as String?) ?? 'Unknown';
            return ResourceRequest(
              id: doc.id,
              title: title,
              authorName: author,
              createdAtLabel: 'recent',
              replyCount: replies,
            );
          }).toList();
        });
  }

  Future<void> postResourceRequest(String title) async {
    if (!FirebaseBootstrap.isAvailable) {
      return;
    }

    final user = auth.currentUser;
    if (user == null) {
      throw StateError('User must be logged in.');
    }

    await firestore.collection('resource_requests').add({
      'title': title,
      'authorId': user.uid,
      'authorName': user.email ?? 'Student',
      'replyCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveProgress({
    required String courseCode,
    required int solvedMcq,
    required int mockTests,
  }) async {
    if (!FirebaseBootstrap.isAvailable) {
      return;
    }
    final user = auth.currentUser;
    if (user == null) {
      return;
    }
    await firestore.collection('users').doc(user.uid).set({
      'progress': {
        'courseCode': courseCode,
        'solvedMcq': solvedMcq,
        'mockTests': mockTests,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    }, SetOptions(merge: true));
  }
}
