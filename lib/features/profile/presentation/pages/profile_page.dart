import 'package:flutter/material.dart';
import 'package:cse_edge/core/firebase/firebase_bootstrap.dart';
import 'package:cse_edge/features/auth/data/auth_service.dart';
import 'package:cse_edge/features/study/data/study_cloud_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          const Row(
            children: [
              CircleAvatar(radius: 28, child: Icon(Icons.person, size: 32)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CSE Student',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text('First Semester'),
                  ],
                ),
              ),
              Chip(label: Text('Night Mode Ready')),
            ],
          ),
          const SizedBox(height: 24),
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
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              color: Color(0xFF0A6BFF),
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
        color: active ? const Color(0xFF0A6BFF) : Colors.white,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
