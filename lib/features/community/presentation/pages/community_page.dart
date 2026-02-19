import 'package:flutter/material.dart';
import 'package:cse_edge/features/study/data/study_cloud_service.dart';
import 'package:cse_edge/features/study/domain/models/resource_request.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final StudyCloudService _studyCloudService = StudyCloudService();

  Future<void> _showRequestDialog() async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post Resource Request'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ex: Need CSE 101 recursion sheet',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  return;
                }
                await _studyCloudService.postResourceRequest(text);
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFFDDEBFF),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student-to-Student Help',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text(
                  'Request slides, sheets, and short notes from peers. Classmates get notified instantly.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: _showRequestDialog,
            child: const Text('Post Resource Request'),
          ),
          const SizedBox(height: 22),
          const Text(
            'Recent Requests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<ResourceRequest>>(
            stream: _studyCloudService.watchResourceRequests(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final requests = snapshot.data ?? const [];
              if (requests.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No requests posted yet.'),
                );
              }
              return Column(
                children: requests
                    .map(
                      (request) => _RequestTile(
                        title: request.title,
                        subtitle:
                            'Posted by ${request.authorName}, ${request.createdAtLabel}',
                        status: request.replyCount == 0
                            ? 'No reply yet'
                            : '${request.replyCount} replies',
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.forum_outlined)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(
          status,
          style: const TextStyle(
            color: Color(0xFF0A6BFF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
