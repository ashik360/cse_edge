import 'package:cse_edge/features/subjects/domain/models/course.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({required this.course, required this.onTapUnit, super.key});

  final Course course;
  final ValueChanged<CourseUnit> onTapUnit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  course.code,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, size: 18),
              ],
            ),
            Text(
              course.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // --- SECTION 1: SUBJECT EXAM ESSENTIALS (DYNAMIC) ---
            _buildSectionHeader(context, "Subject Exam Essentials"),
            ...course.units
                .where((unit) =>
                    unit.type == UnitType.previousQuestion ||
                    unit.type == UnitType.quiz)
                .map(
                  (unit) => _UnitTile(unit: unit, onTap: () => onTapUnit(unit)),
                ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),

            // --- SECTION 2: CHAPTERS & VIDEOS ---
            _buildSectionHeader(context, "Chapters & Lectures"),
            ...course.units
                .where((unit) =>
                    unit.type == UnitType.note ||
                    unit.type == UnitType.video ||
                    unit.type == UnitType.flashcard ||
                    unit.type == UnitType.mockTest)
                .map(
                  (unit) => _UnitTile(unit: unit, onTap: () => onTapUnit(unit)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  const _UnitTile({required this.unit, required this.onTap});

  final CourseUnit unit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = !unit.locked;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(
                _unitIcon(unit.type),
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  unit.title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  IconData _unitIcon(UnitType type) {
    switch (type) {
      case UnitType.note:
        return Icons.description_outlined;
      case UnitType.quiz:
        return Icons.quiz_outlined;
      case UnitType.video:
        return Icons.play_circle_outline;
      case UnitType.previousQuestion:
        return Icons.history_edu;
      case UnitType.flashcard:
        return Icons.style_rounded;
      case UnitType.mockTest:
        return Icons.fact_check_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}