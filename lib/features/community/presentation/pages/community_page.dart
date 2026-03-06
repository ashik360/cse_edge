import 'package:flutter/material.dart';
import 'package:cse_edge/core/constants/app_strings.dart';
import 'package:cse_edge/features/study/data/study_cloud_service.dart';
import 'package:cse_edge/features/study/domain/models/study_resource.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final StudyCloudService _studyCloudService = StudyCloudService();

  // Your exact Firebase request logic remains unchanged
  Future<void> _showRequestDialog() async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  return;
                }
                await _studyCloudService.postResourceRequest(text);
                if (!mounted) return;
                Navigator.of(context).pop();
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.communityTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.forum_outlined), text: 'Discussions'),
              Tab(icon: Icon(Icons.folder_shared_outlined), text: 'Resource Request'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDiscussionsTab(context),
            _buildResourceRequestTab(context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showRequestDialog, // Wired to your Firebase logic
          icon: const Icon(Icons.edit),
          label: const Text('New Post'),
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: DISCUSSIONS (MOCK DATA FOR NOW)
  // ==========================================
  Widget _buildDiscussionsTab(BuildContext context) {
    // You can replace this with another StreamBuilder later for Q&A posts
    final mockDiscussions = [
      {
        'name': 'Rakib Hasan',
        'time': '2 hrs ago',
        'course': 'CSE 311',
        'question': 'Can someone explain the difference between 3NF and BCNF with a simple example? I am stuck on the anomaly part.',
        'upvotes': 12,
        'comments': 4,
      },
      {
        'name': 'Sadia Rahman',
        'time': '5 hrs ago',
        'course': 'CSE 101',
        'question': 'Why does my C program crash when I try to return a local array from a function? What is the correct way to do this?',
        'upvotes': 24,
        'comments': 7,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80, left: 16, right: 16),
      itemCount: mockDiscussions.length,
      itemBuilder: (context, index) {
        final post = mockDiscussions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        (post['name'] as String)[0],
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            post['time'] as String,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post['course'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  post['question'] as String,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                      label: Text('${post['upvotes']} Upvotes'),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined, size: 18),
                      label: Text('${post['comments']} Comments'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // TAB 2: RESOURCE VAULT (REAL FIREBASE DATA)
  // ==========================================
  Widget _buildResourceRequestTab(BuildContext context) {
    return StreamBuilder<List<ResourceRequest>>(
      stream: _studyCloudService.watchResourceRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final requests = snapshot.data ?? const [];
        
        if (requests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open_rounded, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'No requests posted yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 80, left: 16, right: 16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final hasReplies = request.replyCount > 0;

            return Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.orange.withOpacity(0.5), width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'REQUEST',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      request.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Posted by ${request.authorName} • ${request.createdAtLabel}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: FilledButton.tonal(
                  onPressed: () {
                    // Navigate to a reply thread or show dialog
                  },
                  child: Text(hasReplies ? '${request.replyCount} Replies' : 'Reply'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}