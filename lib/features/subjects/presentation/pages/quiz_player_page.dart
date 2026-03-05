import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:flutter/material.dart';
import 'package:cse_edge/features/subjects/presentation/pages/quiz_result_page.dart';

class QuizPlayerPage extends StatefulWidget {
  const QuizPlayerPage({required this.topicTitle, super.key});

  final String topicTitle;

  @override
  State<QuizPlayerPage> createState() => _QuizPlayerPageState();
}

class _QuizPlayerPageState extends State<QuizPlayerPage> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;

  final List<QuizQuestion> _questions = [
    const QuizQuestion(
      question: "What is the time complexity of searching an element in a balanced Binary Search Tree (BST)?",
      options: ["O(n)", "O(log n)", "O(n log n)", "O(1)"],
      correctOptionIndex: 1,
      explanation: "In a balanced BST, the height is log n, so searching takes O(log n) time.",
    ),
    const QuizQuestion(
      question: "Which data structure uses the LIFO (Last In First Out) principle?",
      options: ["Queue", "Linked List", "Stack", "Array"],
      correctOptionIndex: 2,
      explanation: "A Stack follows LIFO, where the last element added is the first one removed.",
    ),
  ];

  void _submitAnswer(int index) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswerIndex = index;
      _isAnswered = true;
      if (index == _questions[_currentIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizResultPage(
          score: _score,
          total: _questions.length,
          topicTitle: widget.topicTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topicTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${_currentIndex + 1}/${_questions.length}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question.question,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(question.options.length, (index) {
                      return _buildOptionTile(index, question);
                    }),
                    if (_isAnswered) ...[
                      const SizedBox(height: 20),
                      _buildFeedbackBox(question),
                      const SizedBox(height: 20), // Extra padding to allow scrolling past feedback
                    ],
                  ],
                ),
              ),
            ),
            // Persistent Bottom Button Area
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isAnswered ? _nextQuestion : null,
                  child: Text(
                    _currentIndex < _questions.length - 1
                        ? "Next Question"
                        : "See Results",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(int index, QuizQuestion question) {
    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (_isAnswered) {
      if (index == question.correctOptionIndex) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
      } else if (index == _selectedAnswerIndex) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
      }
    } else if (_selectedAnswerIndex == index) {
      borderColor = Theme.of(context).primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _submitAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: _isAnswered && index == question.correctOptionIndex
                    ? Colors.green
                    : borderColor,
                child: Text(
                  String.fromCharCode(65 + index),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(question.options[index])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackBox(QuizQuestion question) {
    final isCorrect = _selectedAnswerIndex == question.correctOptionIndex;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.info,
                color: isCorrect ? Colors.green : Colors.blue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? "Correct Explanation" : "Explanation",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}