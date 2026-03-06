import 'package:flutter/material.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/auth/data/auth_service.dart';
import 'package:cse_edge/features/study/data/study_cloud_service.dart';
import 'package:cse_edge/core/firebase/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _loadUserProfile() async {
    if (!FirebaseBootstrap.isAvailable) {
      return null;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return {
        'name': user.displayName,
        'email': user.email,
        'photoURL': user.photoURL,
      };
    }
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'name': data['name'] ?? user.displayName,
      'email': data['email'] ?? user.email,
      'photoURL': data['photoURL'] ?? user.photoURL,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              if (!FirebaseBootstrap.isAvailable) {
                return;
              }
              await AuthService().signOut();
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _loadUserProfile(),
            builder: (context, snapshot) {
              final user = FirebaseAuth.instance.currentUser;
              final hasUser = FirebaseBootstrap.isAvailable && user != null;
              final data = snapshot.data;
              final displayName = hasUser
                  ? (data?['name'] as String?) ??
                      user!.displayName ??
                      user.email ??
                      'Student'
                  : 'Demo User';
              final email = hasUser
                  ? (data?['email'] as String?) ?? user!.email ?? ''
                  : 'Offline Demo';
              final photoUrl =
                  hasUser ? (data?['photoURL'] as String?) ?? user!.photoURL : null;
              final statusLabel = hasUser ? 'Signed In' : 'Demo';

              return Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        photoUrl != null ? NetworkImage(photoUrl) : null,
                    child: photoUrl == null ? const Icon(Icons.person, size: 32) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(email),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(statusLabel),
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // --- App Settings & Testing Section ---
          const Text(
            'App Settings & Testing',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(Icons.notification_important, color: Colors.orange),
              title: const Text("Test Local Notification"),
              subtitle: const Text("Verify if pop-ups are working"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                try {
                  // Call the robust test method
                  await NotificationService.showTestNotification();
                  
                  // Provide user feedback that the call succeeded
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Test notification sent! Check your tray."),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  // Prevent red screen crashes and show exactly what failed
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                }
              },
            ),
          ),

          const SizedBox(height: 32),

          // --- Exam Progress Section ---
          const Text(
            'Exam Progress',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              height: 170,
              width: 170,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 0.64,
                    strokeWidth: 14,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const Center(
                    child: Text(
                      '64%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: _InfoCard(title: 'Solved MCQ', value: '320'),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _InfoCard(title: 'Mock Tests', value: '8'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Study Streak',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayChip(day: 'Mo', active: true),
              _DayChip(day: 'Tu', active: true),
              _DayChip(day: 'We', active: true),
              _DayChip(day: 'Th'),
              _DayChip(day: 'Fr'),
              _DayChip(day: 'Sa'),
              _DayChip(day: 'Su'),
            ],
          ),
          const SizedBox(height: 12),
          const Text('3 active days this week'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await StudyCloudService().saveProgress(
                courseCode: 'CSE 101',
                solvedMcq: 320,
                mockTests: 8,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Progress Synced to Firebase")),
                );
              }
            },
            child: const Text('Sync Progress to Firebase'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day, this.active = false});

  final String day;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: active ? Colors.white : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}