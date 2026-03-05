import 'package:flutter/material.dart';
import 'package:cse_edge/core/theme/app_palette.dart';

class NightBeforePage extends StatelessWidget {
  const NightBeforePage({required this.courseCode, super.key});

  final String courseCode;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1115), // Deep dark for late-night study
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1115),
          foregroundColor: Colors.white,
          title: Text("$courseCode: Final Crush"),
          bottom: const TabBar(
            indicatorColor: AppPalette.primary,
            labelColor: AppPalette.primary,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Formulas", icon: Icon(Icons.functions)),
              Tab(text: "Probables", icon: Icon(Icons.star_border)),
              Tab(text: "Summaries", icon: Icon(Icons.bolt)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRevisionList(_mockFormulas),
            _buildRevisionList(_mockProbables),
            _buildRevisionList(_mockSummaries),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionList(List<Map<String, String>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: const Color(0xFF1C1F26),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            collapsedIconColor: Colors.white,
            iconColor: AppPalette.primary,
            title: Text(
              item['title']!,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppPalette.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item['tag']!,
                style: const TextStyle(color: AppPalette.primary, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  item['content']!,
                  style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Mock Data for the Revision Packs ---
  static const _mockFormulas = [
    {'title': 'Time Complexity Master Theorem', 'tag': 'High Priority', 'content': 'T(n) = aT(n/b) + f(n). Used for recurrence relations. Cases: 1. f(n) < n^log_b(a) -> O(n^log_b(a))...'},
    {'title': 'Disk Scheduling Calculation', 'tag': 'Repeated', 'content': 'Total head movement = Sum of |Request_n - Request_n-1|. FCFS vs SSTF vs SCAN.'},
  ];

  static const _mockProbables = [
    {'title': 'Explain Normalization (1NF to BCNF)', 'tag': 'Common 10-Mark', 'content': 'Focus on functional dependencies. 1NF: Atomic values. 2NF: No partial dependency. 3NF: No transitive dependency.'},
    {'title': 'Deadlock Avoidance - Banker\'s Algorithm', 'tag': 'Expected', 'content': 'Safe state vs Unsafe state. Max Need - Current Allocation = Remaining Need.'},
  ];

  static const _mockSummaries = [
    {'title': 'OS Process Scheduling', 'tag': '2 Min Read', 'content': 'Short-term vs Medium-term vs Long-term. Preemptive vs Non-preemptive. Key Goal: CPU Utilization.'},
  ];
}