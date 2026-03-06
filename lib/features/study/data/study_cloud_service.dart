import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/study/domain/models/study_resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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


// =========================================================
  // NEW: Resource Vault Upload & Retrieval Logic
  // =========================================================

  Future<void> uploadResource({
    required String title,
    required String subjectCode,
    required String category,
    required int year,
    required int semester,
    required String fileUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Must be logged in to upload');

    final docRef = FirebaseFirestore.instance.collection('study_resources').doc();
    
    // Creates a map matching the StudyResource model we discussed
    final resourceData = {
      'id': docRef.id,
      'title': title,
      'subjectCode': subjectCode.toUpperCase(), // Normalize code (e.g., cse 101 -> CSE 101)
      'category': category,
      'year': year,
      'semester': semester,
      'fileUrl': fileUrl,
      'authorName': user.displayName ?? 'Student',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(resourceData);
  }

  Stream<List<Map<String, dynamic>>> watchResourcesForSubject(String subjectCode) {
    return FirebaseFirestore.instance
        .collection('study_resources')
        .where('subjectCode', isEqualTo: subjectCode.toUpperCase())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data())
            .toList());
  }

  // Add these imports at the very top of your file
  // import 'dart:io';
  // import 'package:firebase_storage/firebase_storage.dart';

  Future<void> uploadResourceWithFile({
    required String title,
    required String subjectCode,
    required String category,
    required int year,
    required int semester,
    required File file,
    required String fileName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Must be logged in to upload');

    // 1. Upload the physical file to Firebase Storage
    // We organize them in folders by subject code (e.g., study_resources/CSE 101/...)
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('study_resources')
        .child(subjectCode.toUpperCase())
        .child('${DateTime.now().millisecondsSinceEpoch}_$fileName');

    final uploadTask = await storageRef.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    // 2. Save the metadata and the new download URL to Firestore
    final docRef = FirebaseFirestore.instance.collection('study_resources').doc();
    
    final resourceData = {
      'id': docRef.id,
      'title': title,
      'subjectCode': subjectCode.toUpperCase(),
      'category': category,
      'year': year,
      'semester': semester,
      'fileUrl': downloadUrl, // REAL secure link from Firebase Storage
      'fileName': fileName,
      'authorName': user.displayName ?? 'Student',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(resourceData);
  }

}