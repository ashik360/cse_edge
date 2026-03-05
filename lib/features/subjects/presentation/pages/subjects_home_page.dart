import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:cse_edge/core/firebase/notification_service.dart';
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
  int _selectedYear = 1;
  int _selectedSemester = 1;
  // Inside _SubjectsHomePageState
@override
void initState() {
  super.initState();
  _setupNotifications();
}

Future<void> _setupNotifications() async {
  // Automatically subscribe to the selected semester's updates
  for (var course in _filteredCourses) {
    await NotificationService.subscribeToCourse(course.code);
  }
}

// Also call _setupNotifications() inside your setState when changing semesters

  List<Course> get _filteredCourses {
    return sampleCourses
        .where((c) => c.year == _selectedYear && c.semester == _selectedSemester)
        .toList();
  }

  void _showSemesterPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Academic Session',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: 4, // 4 Years
                  itemBuilder: (context, yearIndex) {
                    final year = yearIndex + 1;
                    return ExpansionTile(
                      leading: const Icon(Icons.calendar_today_outlined),
                      title: Text('Year $year'),
                      children: [1, 2].map((sem) {
                        return ListTile(
                          title: Text('Semester $sem'),
                          onTap: () {
                            setState(() {
                              _selectedYear = year;
                              _selectedSemester = sem;
                            });
                            Navigator.pop(context);
                          },
                          trailing: (_selectedYear == year && _selectedSemester == sem)
                              ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                              : null,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
          // New Selector Design
          InkWell(
            onTap: _showSemesterPicker,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Year $_selectedYear", style: const TextStyle(fontSize: 12)),
                    Text(
                      "Semester $_selectedSemester",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.expand_more_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const NightBeforeBanner(),
          const SizedBox(height: 20),
          if (_filteredCourses.isEmpty)
            const Center(child: Text("No courses added for this semester yet."))
          else
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