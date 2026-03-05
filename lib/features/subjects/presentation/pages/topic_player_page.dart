import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:cse_edge/features/subjects/presentation/pages/document_viewer_page.dart'; // Ensure this import exists
import 'package:cse_edge/features/subjects/presentation/pages/quiz_player_page.dart';
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
      appBar: AppBar(
        title: Text(courseCode),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
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
                  topicTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTypeBadge(context),
                const Divider(height: 32),

                if (type == UnitType.video)
                  _buildVideoPlaylistSection(context)
                else if (type == UnitType.quiz)
                  _buildQuizStartSection(context)
                else
                  _buildDocumentSection(context),
              ],
            ),
          ),
          _buildBottomAction(context),
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
        child: Icon(_iconForType(type), size: 64, color: Colors.white38),
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
        type.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildVideoPlaylistSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Selected Playlists",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        _PlaylistTile(
          title: "Chapter Concept",
          author: "Anisul Islam",
          duration: "25:00",
        ),
        _PlaylistTile(
          title: "Problem Solving",
          author: "Neso Academy",
          duration: "15:00",
        ),
      ],
    );
  }

  Widget _buildQuizStartSection(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.timer_outlined, size: 40, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          "10 Questions • 5 Minutes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDocumentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Study Guide",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Text(AppStrings.topicDescription),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    String label = "Mark as Completed";
    if (type == UnitType.quiz) label = "Start Quiz Test";
    if (type == UnitType.video) label = "Open YouTube Playlist";
    if (type == UnitType.note || type == UnitType.previousQuestion) {
      label = "View Full Document";
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            // NAVIGATION LOGIC FIXED HERE
            if (type == UnitType.quiz) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => QuizPlayerPage(topicTitle: topicTitle),
                ),
              );
            } else if (type == UnitType.note ||
                type == UnitType.previousQuestion) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DocumentViewerPage(
                    title: topicTitle,
                    courseCode: courseCode,
                  ),
                ),
              );
            } else if (type == UnitType.video) {
              // Logic for YouTube redirect
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(label),
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
      case UnitType.video:
        return Icons.ondemand_video_rounded;
      case UnitType.previousQuestion:
        return Icons.history_edu_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({
    required this.title,
    required this.author,
    required this.duration,
  });
  final String title, author, duration;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.play_circle_outline),
      title: Text(title),
      subtitle: Text(author),
      trailing: Text(duration),
    );
  }
}
