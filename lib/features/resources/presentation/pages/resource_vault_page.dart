import 'package:flutter/material.dart';

class ResourceVaultPage extends StatelessWidget {
  const ResourceVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Vault'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Row(
            children: [
              Expanded(
                child: _ScoreCard(
                  label: 'Pending',
                  value: '6',
                  color: Color(0xFFE45245),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ScoreCard(
                  label: 'Avg Score',
                  value: '78%',
                  color: Color(0xFF0A6BFF),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ScoreCard(
                  label: 'Solved',
                  value: '15',
                  color: Color(0xFF2EA44F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFDDEBFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.bookmark_border,
                color: Color(0xFF0A6BFF),
              ),
              title: const Text(
                'Saved Notes and Sheets',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Text(
                '12',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0A6BFF),
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
          const SizedBox(height: 20),
          FilledButton(onPressed: () {}, child: const Text('Start Mock Test')),
        ],
      ),
    );
  }
}

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
        color: highlighted ? const Color(0xFFDDEBFF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE7F0FF),
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
