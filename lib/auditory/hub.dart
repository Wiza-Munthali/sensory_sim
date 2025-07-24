import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AuditoryDisorderSelectionPage extends StatelessWidget {
  const AuditoryDisorderSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Auditory Simulations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          AuditoryDisorderCard(
            icon: Icons.graphic_eq_rounded,
            label: 'Tinnitus',
            description: 'Simulate ringing or buzzing in the ears.',
            routeName: '/tinnitus-sim',
            gradientColors: [Color(0xFFFAD0C4), Color(0xFFFFD1FF)],
          ),
          SizedBox(height: 20),
          AuditoryDisorderCard(
            icon: LucideIcons.volumeX,
            label: 'Muffled Hearing',
            description: 'Experience hearing loss and reduced clarity.',
            routeName: '/muffled-hearing',
            gradientColors: [Color(0xFFCDEAC0), Color(0xFFDEFDE0)],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AuditoryDisorderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final String routeName;
  final List<Color> gradientColors;

  const AuditoryDisorderCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.routeName,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
