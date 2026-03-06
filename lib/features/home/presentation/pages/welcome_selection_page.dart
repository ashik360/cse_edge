import 'package:cse_edge/features/navigation/presentation/pages/main_nav_page.dart';
import 'package:flutter/material.dart';

class WelcomeSelectionPage extends StatefulWidget {
  const WelcomeSelectionPage({super.key});

  @override
  State<WelcomeSelectionPage> createState() => _WelcomeSelectionPageState();
}

class _WelcomeSelectionPageState extends State<WelcomeSelectionPage> {
  int _selectedYear = 1;
  int _selectedSemester = 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- TOP: Modern Semester Selection ---
              const Text(
                "Select Your Session",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildModernSelector(
                title: "Academic Year",
                itemCount: 4,
                selectedIndex: _selectedYear,
                labels: ["1st", "2nd", "3rd", "4th"],
                onChanged: (val) => setState(() => _selectedYear = val),
              ),
              const SizedBox(height: 16),
              _buildModernSelector(
                title: "Semester",
                itemCount: 2,
                selectedIndex: _selectedSemester,
                labels: ["1st", "2nd"],
                onChanged: (val) => setState(() => _selectedSemester = val),
              ),

              const Spacer(flex: 2),

              // --- MIDDLE: Illustration/Image ---
              // Fallback to an icon if home_image.png is missing during testing
              Expanded(
                flex: 5,
                child: Image.asset(
                  'assets/images/home_image.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.rocket_launch_rounded,
                        size: 120,
                        color: colorScheme.primary.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(flex: 1),

              // --- BOTTOM: Motivational Text & CTA ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ready to Debug Your Future?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Every single topic you read today brings you closer to top grades. Let's conquer this semester!",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => MainNavPage(
                                initialYear: _selectedYear,
                                initialSemester: _selectedSemester,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Enter Dashboard",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build modern selectable chips
  Widget _buildModernSelector({
    required String title,
    required int itemCount,
    required int selectedIndex,
    required List<String> labels,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(itemCount, (index) {
            final realValue = index + 1;
            final isSelected = selectedIndex == realValue;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(realValue),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: index == itemCount - 1 ? 0 : 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                        : [],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}