import 'package:cse_edge/features/subjects/presentation/pages/quiz_player_page.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    required this.score,
    required this.total,
    required this.topicTitle,
    super.key,
  });

  final int score;
  final int total;
  final String topicTitle;

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total) * 100;
    final isPassed = percentage >= 60;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPassed ? Icons.emoji_events_outlined : Icons.assignment_late_outlined,
                size: 100,
                color: isPassed ? Colors.orange : Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                isPassed ? "Great Job!" : "Keep Practicing",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "You scored $score out of $total in $topicTitle",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              _buildStatRow("Accuracy", "${percentage.toInt()}%"),
              _buildStatRow("Exam Readiness", isPassed ? "High" : "Needs Review"),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Back to Topic"),
                ),
              ),
              TextButton(
                onPressed: () {
                   Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (_) => QuizPlayerPage(topicTitle: topicTitle))
                   );
                },
                child: const Text("Retake Quiz"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}