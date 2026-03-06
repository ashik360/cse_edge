import 'package:cse_edge/features/study/data/study_cloud_service.dart';
import 'package:flutter/material.dart';
import 'package:cse_edge/core/constants/app_strings.dart'; // Make sure you have this import

class ResourceVaultPage extends StatefulWidget {
  const ResourceVaultPage({super.key});

  @override
  State<ResourceVaultPage> createState() => _ResourceVaultPageState();
}

class _ResourceVaultPageState extends State<ResourceVaultPage> {
  // Method to show the upload form
  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return const _UploadResourceForm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.resourceVault),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      // NEW: Floating Action Button for uploading resources
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadModal(context),
        icon: const Icon(Icons.cloud_upload_outlined),
        label: const Text('Contribute'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  label: 'Pending',
                  value: '6',
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ScoreCard(
                  label: 'Avg Score',
                  value: '78%',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ScoreCard(
                  label: 'Solved',
                  value: '15',
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(
                Icons.bookmark_border,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text(
                'Saved Notes and Sheets',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Text(
                '12',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Question Banks',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          const SizedBox(height: 12),
          const _QuestionBankTile(
            title: 'Structured Programming Final Pack',
            subtitle: '150 solved + unsolved questions',
          ),
          const _QuestionBankTile(
            title: 'Calculus Short Syllabus Drill',
            subtitle: 'Top repeated integration and limit problems',
            highlighted: true,
          ),
          const _QuestionBankTile(
            title: 'EEE Circuit Analysis Capsule',
            subtitle: 'Formula-centric quick practice',
          ),
          const SizedBox(height: 80), // Extra padding for FAB
        ],
      ),
    );
  }
}

// ===================================================================
// NEW: Upload Resource Form Widget (Handles State for the Bottom Sheet)
// ===================================================================
class _UploadResourceForm extends StatefulWidget {
  const _UploadResourceForm();

  @override
  State<_UploadResourceForm> createState() => _UploadResourceFormState();
}

class _UploadResourceFormState extends State<_UploadResourceForm> {
  int _selectedYear = 1;
  int _selectedSemester = 1;
  String _selectedCategory = 'Notes';
  bool _isLoading = false; // Added loading state

  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();

  final List<String> _categories = ['Notes', 'PYQ', 'Quiz'];

  @override
  void dispose() {
    _subjectController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submitResource() async {
    if (_subjectController.text.isEmpty || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Calls the upload method from your service
      await StudyCloudService().uploadResource(
        title: _titleController.text.trim(),
        subjectCode: _subjectController.text.trim(),
        category: _selectedCategory,
        year: _selectedYear,
        semester: _selectedSemester,
        fileUrl: "https://example.com/dummy_link.pdf", // Dummy link for now
      );

      if (!mounted) return;
      Navigator.pop(context); // Close the bottom sheet
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resource uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Padding logic to push content above keyboard
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: bottomInset + 24, // Adapts to keyboard
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contribute a Resource',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Help your peers by sharing materials. Resources will appear in the Subjects tab.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),

          // --- 1. Year & Semester Selectors ---
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
                  value: _selectedYear,
                  items: [1, 2, 3, 4].map((y) => DropdownMenuItem(value: y, child: Text('Year $y'))).toList(),
                  onChanged: (val) => setState(() => _selectedYear = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                  value: _selectedSemester,
                  items: [1, 2].map((s) => DropdownMenuItem(value: s, child: Text('Semester $s'))).toList(),
                  onChanged: (val) => setState(() => _selectedSemester = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- 2. Subject Code & Category ---
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Code',
                    hintText: 'e.g., CSE 101',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  value: _selectedCategory,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- 3. Resource Title ---
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Resource Title',
              hintText: 'e.g., Chapter 1-3 Summary Notes',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // --- 4. File Attachment Mock ---
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
            label: const Text('Attach PDF or Link'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 24),

          // --- 5. Submit Button ---
          FilledButton(
            onPressed: _isLoading ? null : _submitResource,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: _isLoading 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Submit Resource', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// EXISTING UI COMPONENTS (Untouched)
// ===================================================================

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionBankTile extends StatelessWidget {
  const _QuestionBankTile({
    required this.title,
    required this.subtitle,
    this.highlighted = false,
  });

  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: highlighted
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Colors.transparent, // Changed to transparent to fit dark/light mode better
        borderRadius: BorderRadius.circular(14),
        border: highlighted ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.quiz_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.expand_more),
      ),
    );
  }
}