import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/core/constants/app_strings.dart';
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
              AppStrings.topicAboutTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha((0.7 * 255).round()),
                  ],
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.topicDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.topicContinue),
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
