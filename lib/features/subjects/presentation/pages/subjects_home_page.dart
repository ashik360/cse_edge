import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:cse_edge/features/subjects/data/sample_course_data.dart';
import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/features/subjects/presentation/pages/topic_player_page.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/course_card.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/night_before_banner.dart';
import 'package:flutter/material.dart';

class SubjectsHomePage extends StatefulWidget {
  const SubjectsHomePage({super.key});

  @override
  State<SubjectsHomePage> createState() => _SubjectsHomePageState();
}

class _SubjectsHomePageState extends State<SubjectsHomePage> {
  int _selectedSemester = 1;

  List<Course> get _filteredCourses {
    return sampleCourses.where((c) => c.semester == _selectedSemester).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
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
          _buildSemesterSelector(context),
          const SizedBox(height: 8),
          Text(
            AppStrings.examReadinessProgress,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.42,
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          const SizedBox(height: 20),
          const NightBeforeBanner(),
          const SizedBox(height: 20),
          ..._filteredCourses.map(
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

  Widget _buildSemesterSelector(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: _selectedSemester,
      onSelected: (int semester) {
        setState(() {
          _selectedSemester = semester;
        });
      },
      itemBuilder: (BuildContext context) {
        return List.generate(8, (index) => index + 1).map((int semester) {
          return PopupMenuItem<int>(
            value: semester,
            child: Text('Semester $semester'),
          );
        }).toList();
      },
      child: Row(
        children: [
          Text(
            'Semester $_selectedSemester',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
