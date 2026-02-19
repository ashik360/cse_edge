import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:flutter/material.dart';

class TopicPlayerPage extends StatelessWidget {
  const TopicPlayerPage({
    required this.courseCode,
    required this.topicTitle,
    required this.type,
    super.key,
  });

  final String courseCode;
  final String topicTitle;
  final UnitType type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseCode)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About this topic',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976FF), Color(0xFF63A0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(_iconForType(type), size: 72, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              topicTitle,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
            ),
            const SizedBox(height: 8),
            const Text(
              'Focus on important definitions, formulas, and frequently asked exam problems.',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(UnitType unitType) {
    switch (unitType) {
      case UnitType.note:
        return Icons.description_rounded;
      case UnitType.quiz:
        return Icons.quiz_rounded;
      case UnitType.flashcard:
        return Icons.style_rounded;
      case UnitType.video:
        return Icons.ondemand_video_rounded;
      case UnitType.mockTest:
        return Icons.fact_check_rounded;
    }
  }
}
