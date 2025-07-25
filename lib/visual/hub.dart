import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VisualDisorderSelectionPage extends StatelessWidget {
  const VisualDisorderSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Visual Impairment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          VisualDisorderCard(
            icon: LucideIcons.circle,
            label: 'Color Blindness',
            description: 'Simulate deuteranopia, protanopia and tritanopia.',
            routeName: '/color-blindness',
            gradientColors: [Color(0xFFA9D6E5), Color(0xFFCFE0E8)],
          ),
          SizedBox(height: 20),
          VisualDisorderCard(
            icon: LucideIcons.target,
            label: 'Tunnel Vision',
            description: 'Experience the restricted view of glaucoma or RP.',
            routeName: '/tunnel-vision',
            gradientColors: [Color(0xFFD7C4F0), Color(0xFFE0C3FC)],
          ),
          SizedBox(height: 20),
          VisualDisorderCard(
            icon: LucideIcons.scanEye,
            label: 'Blurred Vision',
            description: 'Simulate cataracts or uncorrected refractive error.',
            routeName: '/blurred-vision',
            gradientColors: [Color(0xFFFFD1DC), Color(0xFFFDE2E4)],
          ),
          SizedBox(height: 20),
          VisualDisorderCard(
            icon: LucideIcons.focus,
            label: 'Macular Degeneration',
            description:
                'Experience central vision loss and distortion with camera.',
            routeName: '/macular-degeneration',
            gradientColors: [Color(0xFFE8D5B7), Color(0xFFF4E2C1)],
          ),
          SizedBox(height: 20),
          VisualDisorderCard(
            icon: LucideIcons.eye,
            label: 'Diabetic Retinopathy',
            description:
                'Simulate blood vessel damage and vision complications.',
            routeName: '/diabetic-retinopathy',
            gradientColors: [Color(0xFFFFB3BA), Color(0xFFFFDADD)],
          ),
        ],
      ),
    );
  }
}

class VisualDisorderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final String routeName;
  final List<Color> gradientColors;

  const VisualDisorderCard({
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
