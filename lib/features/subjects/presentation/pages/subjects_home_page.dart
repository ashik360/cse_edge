import 'package:cse_edge/core/firebase/notification_service.dart';
import 'package:cse_edge/features/subjects/data/course_repository.dart';
import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/features/subjects/presentation/pages/topic_player_page.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/course_card.dart';
import 'package:cse_edge/features/subjects/presentation/widgets/night_before_banner.dart';
import 'package:flutter/material.dart';

class SubjectsHomePage extends StatefulWidget {
  const SubjectsHomePage({
    this.initialYear = 1,
    this.initialSemester = 1,
    super.key,
  });

  final int initialYear;
  final int initialSemester;

  @override
  State<SubjectsHomePage> createState() => _SubjectsHomePageState();
}

class _SubjectsHomePageState extends State<SubjectsHomePage> {
  late int _selectedYear;
  late int _selectedSemester;

  final CourseRepository _courseRepository = CourseRepository();

  final List<Map<String, String>> _notificationHistory = [
    {
      'title': '🔥 Probable Questions Updated!',
      'body': 'New 10-mark questions added for Database Normalization.',
      'time': '10 mins ago',
    },
    {
      'title': 'New Note Added',
      'body': 'Someone just added a recursion sheet for CSE 101.',
      'time': '2 hours ago',
    },
    {
      'title': 'Exam Reminder',
      'body': 'Don\'t forget to review the Night Before capsule!',
      'time': 'Yesterday',
    },
  ];

  String getOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return "${number}th";
    }

    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _selectedSemester = widget.initialSemester;
  }

  Future<void> _setupNotifications(List<Course> courses) async {
    for (final course in courses) {
      await NotificationService.subscribeToCourse(course.code);
    }
  }

  Stream<List<Course>> get _coursesStream {
    return _courseRepository.watchCourses(
      year: _selectedYear,
      semester: _selectedSemester,
    );
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
                  itemCount: 4,
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
                          trailing:
                              (_selectedYear == year &&
                                  _selectedSemester == sem)
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                )
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

  void _openTopic(BuildContext context, Course course, CourseUnit unit) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => TopicPlayerPage(
        courseCode: course.code,
        unit: unit,
      ),
    ),
  );
}

  Widget _buildNotificationDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Updates",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: _notificationHistory.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notif = _notificationHistory[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    title: Text(
                      notif['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif['body']!),
                          const SizedBox(height: 6),
                          Text(
                            notif['time']!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            SizedBox(height: 60),
            Icon(Icons.cloud_off_rounded, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              "No courses added for this semester yet.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _buildNotificationDrawer(context),
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showSemesterPicker,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .18,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  " ${getOrdinal(_selectedYear)} Year • $_selectedSemester Sem",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ],
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Badge(
                  child: Icon(Icons.notifications_none_rounded),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Course>>(
        stream: _coursesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load courses.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final courses = snapshot.data ?? const [];

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && courses.isNotEmpty) {
              _setupNotifications(courses);
            }
          });

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const NightBeforeBanner(),
              const SizedBox(height: 20),
              if (courses.isEmpty)
                _buildEmptyState()
              else
                ...courses.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(
                      course: course,
                      onTapUnit: (unit) => _openTopic(context, course, unit),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
