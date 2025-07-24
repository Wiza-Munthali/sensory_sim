
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SensorySimHomePage extends StatelessWidget {
  const SensorySimHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'SensorySim',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          SensoryOptionCard(
            icon: LucideIcons.eye,
            label: 'Visual Simulation',
            description:
                'Simulate visual impairments like color blindness or tunnel vision.',
            routeName: '/visual',
            gradientColors: [Color(0xFFC8E8E3), Color(0xFFA9D6E5)],
          ),
          SizedBox(height: 20),
          SensoryOptionCard(
            icon: LucideIcons.headphones,
            label: 'Auditory Simulation',
            description:
                'Experience audio distortions like tinnitus or muffled sounds.',
            routeName: '/auditory',
            gradientColors: [Color(0xFFD8CFF1), Color(0xFFB8C6FF)],
          ),
          SizedBox(height: 20),
          // SensoryOptionCard(
          //   icon: LucideIcons.vibrate,
          //   label: 'Sensory Overload',
          //   description:
          //       'Simulate hypersensitivity and environmental distractions.',
          //   routeName: '/overload',
          //   gradientColors: [Color(0xFFFFE0C1), Color(0xFFFFC7C7)],
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class SensoryOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final String routeName;
  final List<Color> gradientColors;

  const SensoryOptionCard({
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
