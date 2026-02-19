import 'package:cse_edge/features/subjects/data/sample_course_data.dart';
import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/features/subjects/presentation/pages/topic_player_page.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/course_card.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/night_before_banner.dart';
import 'package:flutter/material.dart';

class SubjectsHomePage extends StatelessWidget {
  const SubjectsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSE EDGE',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              const Text(
                'Semester 1',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade700,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Exam readiness progress',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.42),
          const SizedBox(height: 20),
          const NightBeforeBanner(),
          const SizedBox(height: 20),
          ...semesterOneCourses.map(
            (course) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CourseCard(
                course: course,
                onTapUnit: (unit) => _openTopic(context, course, unit),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openTopic(BuildContext context, Course course, CourseUnit unit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TopicPlayerPage(
          courseCode: course.code,
          topicTitle: unit.title,
          type: unit.type,
        ),
      ),
    );
  }
}
