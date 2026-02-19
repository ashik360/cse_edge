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
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${course.completedUnits}/${course.units.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A6BFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              course.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 14),
            ...course.units.map(
              (unit) => _UnitTile(unit: unit, onTap: () => onTapUnit(unit)),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFE7F0FF),
                child: Icon(
                  _unitIcon(unit.type),
                  color: const Color(0xFF0A6BFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  unit.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  unit.completed ? Icons.check_circle : Icons.bookmark_border,
                  color: unit.completed ? Colors.green : null,
                ),
              ),
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
      case UnitType.flashcard:
        return Icons.style_outlined;
      case UnitType.video:
        return Icons.play_circle_outline;
      case UnitType.mockTest:
        return Icons.fact_check_outlined;
    }
  }
}
