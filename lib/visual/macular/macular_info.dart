import 'package:flutter/material.dart';
import 'dart:math';

class MacularDegenerationInfoPage extends StatefulWidget {
  const MacularDegenerationInfoPage({super.key});

  @override
  State<MacularDegenerationInfoPage> createState() =>
      _MacularDegenerationInfoPageState();
}

class _MacularDegenerationInfoPageState
    extends State<MacularDegenerationInfoPage> {
  int _selectedStage = 0;
  bool _showSimulation = false;

  final List<Map<String, dynamic>> _stages = [
    {
      'name': 'Normal Vision',
      'description': 'Healthy macula with clear central vision',
      'prevalence': 'Baseline reference',
    },
    {
      'name': 'Early AMD',
      'description':
          'Small drusen deposits under the retina, minimal vision change',
      'prevalence': '~8% of people over 50',
    },
    {
      'name': 'Intermediate AMD',
      'description':
          'Larger drusen, possible pigment changes, some vision loss',
      'prevalence': '~13% of people over 75',
    },
    {
      'name': 'Late Dry AMD',
      'description': 'Geographic atrophy with significant central vision loss',
      'prevalence': '~7% of people over 75',
    },
    {
      'name': 'Wet AMD',
      'description': 'Abnormal blood vessels leak, rapid severe vision loss',
      'prevalence': '~2% of people over 75',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Macular Degeneration Education',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stage selector
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _stages.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedStage == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStage = index;
                      _showSimulation = index != 0;
                    });
                  },
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.amber.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _stages[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                isSelected
                                    ? Colors.amber.shade800
                                    : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _stages[index]['prevalence'],
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isSelected
                                    ? Colors.amber.shade600
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
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _stages[_selectedStage]['description'],
              style: TextStyle(color: Colors.green.shade800, fontSize: 14),
            ),
          ),

          // Scenarios
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildScenarioCard(
                  'Central Vision Loss',
                  'Progressive loss of central vision while peripheral remains',
                  _buildCentralVisionDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Reading Difficulty',
                  'Impact on reading and detailed tasks',
                  _buildReadingDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Face Recognition',
                  'Difficulty recognizing faces and details',
                  _buildFaceRecognitionDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Amsler Grid Test',
                  'Standard test used to detect macular problems',
                  _buildAmslerGridDemo(),
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

  Widget _buildCentralVisionDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVisionColumn('Normal Vision', false),
        if (_showSimulation) _buildVisionColumn('With AMD', true),
      ],
    );
  }

  Widget _buildVisionColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade300],
              ),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                // Background scene
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: ScenePainter(),
                      size: const Size(100, 100),
                    ),
                  ),
                ),
                // Central vision loss overlay
                if (simulate) _buildCentralVisionLoss(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralVisionLoss() {
    double blurRadius = _getCentralBlurRadius();
    Color lossColor = _getCentralLossColor();

    return Center(
      child: Container(
        width: blurRadius,
        height: blurRadius,
        decoration: BoxDecoration(color: lossColor, shape: BoxShape.circle),
      ),
    );
  }

  double _getCentralBlurRadius() {
    switch (_selectedStage) {
      case 1:
        return 20; // Early - small spot
      case 2:
        return 35; // Intermediate - medium spot
      case 3:
        return 50; // Late dry - large spot
      case 4:
        return 60; // Wet - very large spot
      default:
        return 0;
    }
  }

  Color _getCentralLossColor() {
    switch (_selectedStage) {
      case 1:
        return Colors.yellow.withOpacity(0.3); // Early - slight tint
      case 2:
        return Colors.orange.withOpacity(0.5); // Intermediate - more noticeable
      case 3:
        return Colors.brown.withOpacity(0.7); // Late dry - significant loss
      case 4:
        return Colors.black.withOpacity(0.8); // Wet - severe loss
      default:
        return Colors.transparent;
    }
  }

  Widget _buildReadingDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildReadingColumn('Normal Reading', false),
        if (_showSimulation) _buildReadingColumn('With AMD', true),
      ],
    );
  }

  Widget _buildReadingColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Stack(
              children: [
                const Text(
                  'LOREM IPSUM\n\nThe quick brown fox\njumps over the lazy\ndog. This sentence\ncontains every letter\nof the alphabet.\n\nReading becomes\nprogressively more\ndifficult with AMD.',
                  style: TextStyle(fontSize: 11),
                ),
                if (simulate) _buildReadingObstruction(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingObstruction() {
    return Positioned(
      top: 30,
      left: 15,
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: _getCentralLossColor(),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildFaceRecognitionDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFaceColumn('Normal Vision', false),
        if (_showSimulation) _buildFaceColumn('With AMD', true),
      ],
    );
  }

  Widget _buildFaceColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Simple face representation
                Center(
                  child: Container(
                    width: 80,
                    height: 100,
                    child: CustomPaint(
                      painter: FacePainter(),
                      size: const Size(80, 100),
                    ),
                  ),
                ),
                // Central obstruction for simulation
                if (simulate)
                  Positioned(
                    top: 35,
                    left: 25,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getCentralLossColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmslerGridDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGridColumn('Normal Grid', false),
        if (_showSimulation) _buildGridColumn('Distorted Grid', true),
      ],
    );
  }

  Widget _buildGridColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
            ),
            child: CustomPaint(
              painter: AmslerGridPainter(simulate, _selectedStage),
              size: const Size(120, 120),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            simulate
                ? 'Lines may appear\nwavy or missing'
                : 'Straight parallel\nlines',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class ScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw simple scene elements
    // Sky
    paint.color = Colors.lightBlue.shade200;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.6), paint);

    // Ground
    paint.color = Colors.green.shade300;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      paint,
    );

    // Tree
    paint.color = Colors.brown.shade400;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.7, size.height * 0.4, 8, 25),
      paint,
    );

    paint.color = Colors.green.shade600;
    canvas.drawCircle(Offset(size.width * 0.74, size.height * 0.35), 12, paint);

    // House
    paint.color = Colors.red.shade300;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.45, 25, 20),
      paint,
    );

    paint.color = Colors.blue.shade800;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.5, 6, 8),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Face outline
    paint.color = const Color(0xFFFFE5B4); // Peach color
    canvas.drawOval(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 30),
      paint,
    );

    // Eyes
    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.35), 3, paint);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.35), 3, paint);

    // Nose
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    Path nose = Path();
    nose.moveTo(size.width * 0.5, size.height * 0.45);
    nose.lineTo(size.width * 0.48, size.height * 0.55);
    canvas.drawPath(nose, paint);

    // Mouth
    Path mouth = Path();
    mouth.moveTo(size.width * 0.4, size.height * 0.65);
    mouth.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.7,
      size.width * 0.6,
      size.height * 0.65,
    );
    canvas.drawPath(mouth, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AmslerGridPainter extends CustomPainter {
  final bool simulate;
  final int stage;

  AmslerGridPainter(this.simulate, this.stage);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    const gridSize = 10;

    // Draw vertical lines
    for (int i = 0; i <= gridSize; i++) {
      double x = (size.width / gridSize) * i;

      if (simulate && stage >= 2 && i >= 4 && i <= 6) {
        // Draw wavy lines for central distortion
        Path wavyLine = Path();
        wavyLine.moveTo(x, 0);

        for (int j = 0; j <= 20; j++) {
          double y = (size.height / 20) * j;
          double waveOffset = sin((j / 5) * pi) * (stage >= 3 ? 8 : 4);
          wavyLine.lineTo(x + waveOffset, y);
        }
        canvas.drawPath(wavyLine, paint);
      } else {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
    }

    // Draw horizontal lines
    for (int i = 0; i <= gridSize; i++) {
      double y = (size.height / gridSize) * i;

      if (simulate && stage >= 2 && i >= 4 && i <= 6) {
        // Draw wavy lines for central distortion
        Path wavyLine = Path();
        wavyLine.moveTo(0, y);

        for (int j = 0; j <= 20; j++) {
          double x = (size.width / 20) * j;
          double waveOffset = sin((j / 5) * pi) * (stage >= 3 ? 8 : 4);
          wavyLine.lineTo(x, y + waveOffset);
        }
        canvas.drawPath(wavyLine, paint);
      } else {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }

    // Add central missing area for advanced stages
    if (simulate && stage >= 3) {
      final missingPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        stage == 4 ? 20 : 15,
        missingPaint,
      );
    }

    // Draw center dot
    final centerPaint =
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
