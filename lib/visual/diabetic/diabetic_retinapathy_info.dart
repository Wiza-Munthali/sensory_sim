import 'package:flutter/material.dart';
import 'dart:math';

class DiabeticRetinopathyInfoPage extends StatefulWidget {
  const DiabeticRetinopathyInfoPage({super.key});

  @override
  State<DiabeticRetinopathyInfoPage> createState() =>
      _DiabeticRetinopathyInfoPageState();
}

class _DiabeticRetinopathyInfoPageState
    extends State<DiabeticRetinopathyInfoPage>
    with TickerProviderStateMixin {
  int _selectedStage = 0;
  bool _showSimulation = false;
  late AnimationController _floaterController;

  final List<Map<String, dynamic>> _stages = [
    {
      'name': 'Normal Vision',
      'description': 'Healthy retina with clear vision and no complications',
      'prevalence': 'Baseline reference',
    },
    {
      'name': 'Mild NPDR',
      'description': 'Small balloon-like swellings in retinal blood vessels',
      'prevalence': '~40% of diabetics after 5 years',
    },
    {
      'name': 'Moderate NPDR',
      'description': 'Blood vessels that nourish the retina become blocked',
      'prevalence': '~53% of diabetics after 15 years',
    },
    {
      'name': 'Severe NPDR',
      'description': 'Many blood vessels are blocked, retina lacks oxygen',
      'prevalence': '~28% of those with moderate NPDR progress',
    },
    {
      'name': 'Proliferative DR',
      'description': 'New abnormal blood vessels grow, may cause vision loss',
      'prevalence': '~75% of severe NPDR cases progress',
    },
  ];

  @override
  void initState() {
    super.initState();
    _floaterController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Diabetic Retinopathy Education',
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
                      color: isSelected ? Colors.red.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.grey.shade300,
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
                                    ? Colors.red.shade800
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
                                    ? Colors.red.shade600
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
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _stages[_selectedStage]['description'],
              style: TextStyle(color: Colors.purple.shade800, fontSize: 14),
            ),
          ),

          // Scenarios
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildScenarioCard(
                  'Central Vision',
                  'How central vision is affected by retinal damage',
                  _buildCentralVisionDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Blood Vessel Changes',
                  'Visualization of retinal blood vessel damage',
                  _buildBloodVesselDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Floaters & Spots',
                  'Dark spots and floaters in vision field',
                  _buildFloatersDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Reading Difficulty',
                  'Impact on close-up tasks and reading',
                  _buildReadingDemo(),
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
        if (_showSimulation) _buildVisionColumn('With DR', true),
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
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Stack(
              children: [
                // Background grid pattern
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: CustomPaint(
                      painter: GridPainter(),
                      size: const Size(80, 80),
                    ),
                  ),
                ),
                // Central vision effects
                if (simulate)
                  Positioned.fill(child: _buildCentralVisionEffects()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralVisionEffects() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // Dark spots for severe stages
          if (_selectedStage >= 3)
            Positioned(
              top: 30,
              left: 45,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          // Larger central blur for proliferative
          if (_selectedStage == 4)
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          // Add effects for moderate stage
          if (_selectedStage == 2)
            Positioned(
              top: 40,
              left: 50,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBloodVesselDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildVesselColumn('Normal Vessels', false),
        if (_showSimulation) _buildVesselColumn('Damaged Vessels', true),
      ],
    );
  }

  Widget _buildVesselColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: BloodVesselPainter(simulate, _selectedStage),
              size: const Size(120, 80),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatersDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFloaterColumn('Normal Vision', false),
        if (_showSimulation) _buildFloaterColumn('With Floaters', true),
      ],
    );
  }

  Widget _buildFloaterColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Background text
                const Center(
                  child: Text(
                    'Sample\nText\nHere',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Animated floaters
                if (simulate && _selectedStage >= 3)
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _floaterController,
                      builder: (context, child) {
                        return SizedBox(
                          width: 120,
                          height: 100,
                          child: Stack(children: _buildFloaters()),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloaters() {
    List<Widget> floaters = [];
    int floaterCount = _selectedStage == 3 ? 2 : 4;

    for (int i = 0; i < floaterCount; i++) {
      double animationOffset = (_floaterController.value + i * 0.3) % 1.0;
      double x = 10 + (80 * animationOffset);
      double y = 10 + (60 * sin(animationOffset * 2 * pi + i));

      floaters.add(
        Positioned(
          left: x,
          top: y,
          child: Container(
            width: _selectedStage == 4 ? 8 : 5,
            height: _selectedStage == 4 ? 8 : 5,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return floaters;
  }

  Widget _buildReadingDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildReadingColumn('Normal Reading', false),
        if (_showSimulation) _buildReadingColumn('With DR', true),
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
                  'The quick brown\nfox jumps over\nthe lazy dog.\n\nThis text shows\nhow diabetic\nretinopathy\naffects reading.',
                  style: TextStyle(fontSize: 12),
                ),
                if (simulate) Positioned.fill(child: _buildReadingEffects()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingEffects() {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Blur effects for different stages
          if (_selectedStage >= 2)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                width: 30,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          if (_selectedStage >= 4)
            Positioned(
              top: 50,
              left: 10,
              child: Container(
                width: 40,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade400
          ..strokeWidth = 1;

    // Draw vertical lines
    for (int i = 0; i <= 4; i++) {
      double x = (size.width / 4) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (int i = 0; i <= 4; i++) {
      double y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BloodVesselPainter extends CustomPainter {
  final bool simulate;
  final int stage;

  BloodVesselPainter(this.simulate, this.stage);

  @override
  void paint(Canvas canvas, Size size) {
    final normalPaint =
        Paint()
          ..color = Colors.red.shade300
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final damagedPaint =
        Paint()
          ..color = Colors.red.shade700
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    final blockedPaint =
        Paint()
          ..color = Colors.black54
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    // Draw main vessel
    Path mainVessel = Path();
    mainVessel.moveTo(10, size.height / 2);
    mainVessel.quadraticBezierTo(
      size.width / 2,
      10,
      size.width - 10,
      size.height / 2,
    );

    // Draw branches
    Path branch1 = Path();
    branch1.moveTo(size.width / 3, size.height / 3);
    branch1.lineTo(size.width / 3, size.height - 10);

    Path branch2 = Path();
    branch2.moveTo(2 * size.width / 3, size.height / 3);
    branch2.lineTo(2 * size.width / 3, size.height - 10);

    if (simulate) {
      // Different damage based on stage
      Paint vesselPaint = stage >= 3 ? blockedPaint : damagedPaint;
      canvas.drawPath(mainVessel, vesselPaint);

      if (stage >= 2) {
        canvas.drawPath(branch1, vesselPaint);
      }
      if (stage >= 3) {
        canvas.drawPath(branch2, blockedPaint);
      }

      // Add hemorrhages for severe stages
      if (stage >= 4) {
        final hemorrhagePaint = Paint()..color = Colors.red.shade900;
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          3,
          hemorrhagePaint,
        );
        canvas.drawCircle(
          Offset(size.width / 4, size.height / 4),
          2,
          hemorrhagePaint,
        );
      }
    } else {
      // Normal vessels
      canvas.drawPath(mainVessel, normalPaint);
      canvas.drawPath(branch1, normalPaint);
      canvas.drawPath(branch2, normalPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
