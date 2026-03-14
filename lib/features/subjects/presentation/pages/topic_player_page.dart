import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/features/subjects/presentation/pages/document_viewer_page.dart';
import 'package:cse_edge/features/subjects/presentation/pages/quiz_player_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TopicPlayerPage extends StatelessWidget {
  const TopicPlayerPage({
    required this.courseCode,
    required this.unit,
    super.key,
  });

  final String courseCode;
  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseCode),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderContent(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  unit.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTypeBadge(context),
                const Divider(height: 32),
                if (unit.type == UnitType.video)
                  _buildVideoSection(context)
                else if (unit.type == UnitType.quiz)
                  _buildQuizStartSection(context)
                else if (unit.type == UnitType.note ||
                    unit.type == UnitType.previousQuestion)
                  _buildDocumentSection(context)
                else
                  const Text('No content available.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: Icon(
          _iconForType(unit.type),
          size: 64,
          color: Colors.white38,
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        unit.type.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context) {
    if (unit.videos.isEmpty) {
      return const Center(
        child: Text('No videos added yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video Tutorials',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...unit.videos.map(
          (video) => Card(
            child: ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text(video.title),
              subtitle: Text(
                [
                  if (video.author.isNotEmpty) video.author,
                  if (video.duration.isNotEmpty) video.duration,
                ].join(' • '),
              ),
              onTap: () => _openUrl(video.url),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizStartSection(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => QuizPlayerPage(topicTitle: unit.title),
            ),
          );
        },
        child: const Text('Start Quiz'),
      ),
    );
  }

  Widget _buildDocumentSection(BuildContext context) {
    if (unit.files.isEmpty) {
      return const Center(
        child: Text('No files added yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Study Materials',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...unit.files.map(
          (file) => Card(
            child: ListTile(
              leading: Icon(_fileIcon(file.fileType)),
              title: Text(file.title),
              subtitle: Text(file.fileType.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DocumentViewerPage(
                      title: file.title,
                      courseCode: courseCode,
                      fileUrl: file.url,
                      fileType: file.fileType,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  IconData _fileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'drive':
        return Icons.cloud_rounded;
      case 'image':
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  IconData _iconForType(UnitType unitType) {
    switch (unitType) {
      case UnitType.note:
        return Icons.description_rounded;
      case UnitType.quiz:
        return Icons.quiz_rounded;
      case UnitType.video:
        return Icons.ondemand_video_rounded;
      case UnitType.previousQuestion:
        return Icons.history_edu_rounded;
      case UnitType.flashcard:
        return Icons.style_rounded;
      case UnitType.mockTest:
        return Icons.fact_check_rounded;
    }
  }
}