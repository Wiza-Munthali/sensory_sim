import 'package:flutter/material.dart';
import 'dart:math';

class TunnelVisionInfoPage extends StatefulWidget {
  const TunnelVisionInfoPage({super.key});

  @override
  State<TunnelVisionInfoPage> createState() => _TunnelVisionInfoPageState();
}

class _TunnelVisionInfoPageState extends State<TunnelVisionInfoPage> {
  int _selectedType = 0;
  bool _showSimulation = false;

  final List<Map<String, dynamic>> _tunnelTypes = [
    {
      'name': 'Normal Vision',
      'description': 'Full field of vision with clear peripheral awareness',
      'prevalence': 'Baseline reference',
    },
    {
      'name': 'Mild Glaucoma',
      'description': 'Early peripheral vision loss, often unnoticed',
      'prevalence': '~3% of people over 40',
    },
    {
      'name': 'Moderate Glaucoma',
      'description': 'Noticeable peripheral vision gaps and blind spots',
      'prevalence': '~1.5% of people over 65',
    },
    {
      'name': 'Advanced Glaucoma',
      'description': 'Severe tunnel vision with significant peripheral loss',
      'prevalence': '~0.5% of glaucoma patients',
    },
    {
      'name': 'Retinitis Pigmentosa',
      'description': 'Progressive peripheral vision loss from genetic disorder',
      'prevalence': '~1 in 4,000 people',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
         leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Tunnel Vision Education',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
         actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Type selector
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _tunnelTypes.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedType == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = index;
                      _showSimulation = index != 0;
                    });
                  },
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.indigo.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected ? Colors.indigo : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tunnelTypes[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                isSelected
                                    ? Colors.indigo.shade800
                                    : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _tunnelTypes[index]['prevalence'],
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isSelected
                                    ? Colors.indigo.shade600
                                    : Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Description
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _tunnelTypes[_selectedType]['description'],
              style: TextStyle(color: Colors.cyan.shade800, fontSize: 14),
            ),
          ),

          // Scenarios
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildScenarioCard(
                  'Field of Vision',
                  'How peripheral vision loss creates tunnel effect',
                  _buildFieldOfVisionDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Navigation Challenges',
                  'Difficulty navigating obstacles and crowded spaces',
                  _buildNavigationDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Driving Impact',
                  'Effects on driving safety and lane awareness',
                  _buildDrivingDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Daily Activities',
                  'Impact on sports, stairs, and spatial awareness',
                  _buildActivitiesDemo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(String title, String description, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildFieldOfVisionDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVisionFieldColumn('Normal Field', false),
        if (_showSimulation) _buildVisionFieldColumn('Tunnel Vision', true),
      ],
    );
  }

  Widget _buildVisionFieldColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                // Background scene
                Container(
                  width: 140,
                  height: 140,
                  child: CustomPaint(
                    painter: VisionFieldPainter(),
                    size: const Size(140, 140),
                  ),
                ),
                // Tunnel vision overlay
                if (simulate) _buildTunnelOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTunnelOverlay() {
    double tunnelRadius = _getTunnelRadius();

    return Container(
      width: 140,
      height: 140,
      child: CustomPaint(
        painter: TunnelOverlayPainter(tunnelRadius),
        size: const Size(140, 140),
      ),
    );
  }

  double _getTunnelRadius() {
    switch (_selectedType) {
      case 1:
        return 50; // Mild - slight restriction
      case 2:
        return 40; // Moderate - noticeable tunnel
      case 3:
        return 25; // Advanced - severe tunnel
      case 4:
        return 20; // RP - very narrow tunnel
      default:
        return 70; // Normal - full field
    }
  }

  Widget _buildNavigationDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavigationColumn('Normal Navigation', false),
        if (_showSimulation) _buildNavigationColumn('With Tunnel Vision', true),
      ],
    );
  }

  Widget _buildNavigationColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Background obstacles
                CustomPaint(
                  size: const Size(120, 100),
                  painter: ObstaclePainter(),
                ),
                // Person walking
                const Positioned(
                  bottom: 10,
                  left: 55,
                  child: Icon(Icons.person, size: 20, color: Colors.blue),
                ),
                // Vision overlay
                if (simulate) _buildNavigationOverlay(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationOverlay() {
    return Container(
      width: 120,
      height: 100,
      child: CustomPaint(
        painter: NavigationTunnelPainter(_getTunnelRadius() * 0.5),
        size: const Size(120, 100),
      ),
    );
  }

  Widget _buildDrivingDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDrivingColumn('Normal Driving View', false),
        if (_showSimulation) _buildDrivingColumn('Tunnel Vision Driving', true),
      ],
    );
  }

  Widget _buildDrivingColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Road and lanes
                CustomPaint(size: const Size(120, 80), painter: RoadPainter()),
                // Tunnel overlay for driving
                if (simulate) _buildDrivingTunnelOverlay(),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            simulate ? 'Reduced lane\nawareness' : 'Full peripheral\nawareness',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildDrivingTunnelOverlay() {
    return Container(
      width: 120,
      height: 80,
      child: CustomPaint(
        painter: DrivingTunnelPainter(_getTunnelRadius() * 0.4),
        size: const Size(120, 80),
      ),
    );
  }

  Widget _buildActivitiesDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActivitiesColumn('Normal Activities', false),
        if (_showSimulation) _buildActivitiesColumn('With Tunnel Vision', true),
      ],
    );
  }

  Widget _buildActivitiesColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Column(
            children: [
              _buildActivityItem('🏀 Ball Sports', simulate),
              const SizedBox(height: 8),
              _buildActivityItem('🚶 Stairs Navigation', simulate),
              const SizedBox(height: 8),
              _buildActivityItem('🚗 Parking', simulate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, bool simulate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: simulate ? Colors.orange.shade100 : Colors.green.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: simulate ? Colors.orange.shade300 : Colors.green.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(activity, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Icon(
            simulate ? Icons.warning_amber : Icons.check_circle,
            size: 12,
            color: simulate ? Colors.orange.shade700 : Colors.green.shade700,
          ),
        ],
      ),
    );
  }
}

class VisionFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw concentric circles to represent field of vision
    for (int i = 1; i <= 3; i++) {
      paint
        ..color = Colors.blue.withOpacity(0.2 * i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        (size.width / 2) * (i / 3),
        paint,
      );
    }

    // Add objects in different areas
    paint.style = PaintingStyle.fill;

    // Central object
    paint.color = Colors.red;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 8, paint);

    // Peripheral objects
    paint.color = Colors.orange;
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 6, paint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 6, paint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.8), 6, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.8), 6, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TunnelOverlayPainter extends CustomPainter {
  final double tunnelRadius;

  TunnelOverlayPainter(this.tunnelRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.8)
          ..style = PaintingStyle.fill;

    // Create a path for the tunnel effect
    Path path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
    );

    // Subtract the tunnel area
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: tunnelRadius,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ObstaclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw obstacles (people, poles, etc.)
    paint.color = Colors.brown;
    canvas.drawRect(Rect.fromLTWH(10, 20, 8, 40), paint); // Left pole
    canvas.drawRect(Rect.fromLTWH(102, 20, 8, 40), paint); // Right pole

    paint.color = Colors.purple;
    canvas.drawCircle(Offset(25, 30), 8, paint); // Left person
    canvas.drawCircle(Offset(95, 35), 8, paint); // Right person

    // Draw path
    paint.color = Colors.grey.shade300;
    canvas.drawRect(Rect.fromLTWH(40, 0, 40, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NavigationTunnelPainter extends CustomPainter {
  final double tunnelRadius;

  NavigationTunnelPainter(this.tunnelRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.7)
          ..style = PaintingStyle.fill;

    // Create tunnel effect for navigation
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height - 10),
        radius: tunnelRadius,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw road
    paint.color = Colors.grey.shade600;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw lane markings
    paint.color = Colors.white;
    paint.strokeWidth = 2;

    // Center line
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width / 2, i * 20.0),
        Offset(size.width / 2, i * 20.0 + 10),
        paint,
      );
    }

    // Side cars
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 20, 15, 8),
        const Radius.circular(2),
      ),
      paint,
    );

    paint.color = Colors.red;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(100, 25, 15, 8),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DrivingTunnelPainter extends CustomPainter {
  final double tunnelRadius;

  DrivingTunnelPainter(this.tunnelRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.8)
          ..style = PaintingStyle.fill;

    // Create tunnel effect for driving
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: tunnelRadius,
      ),
    );

    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
