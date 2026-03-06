import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:cse_edge/core/firebase/notification_service.dart';
import 'package:cse_edge/features/subjects/data/sample_course_data.dart';
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

  // Mock history of notifications to display in the new Drawer.
  // In a production app, you would load these from SharedPreferences or SQLite.
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

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
    _selectedSemester = widget.initialSemester;
    
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    for (var course in _filteredCourses) {
      await NotificationService.subscribeToCourse(course.code);
    }
  }

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
                            _setupNotifications();
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
      // The End Drawer for Notification History
      endDrawer: _buildNotificationDrawer(context),
      appBar: AppBar(
        // Modernized Title/Selector
        title: GestureDetector(
          onTap: _showSemesterPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
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
                  "Year $_selectedYear • Sem $_selectedSemester",
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
          // Wrapped in a Builder to get the Scaffold context for opening the endDrawer
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Badge(
                  child: Icon(Icons.notifications_none_rounded),
                ),
              );
            }
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Selector removed from here, now in AppBar!
          const NightBeforeBanner(),
          const SizedBox(height: 20),
          if (_filteredCourses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Icon(Icons.cloud_off_rounded, size: 60, color: Colors.grey,),
                    Text(
                      "No courses added for this semester yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            )
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

  // Modern Drawer UI for Notification History
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
                  const Icon(Icons.notifications_active_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Text(
                    "Updates",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  )
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text(
                      notif['title']!,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
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
                            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary),
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