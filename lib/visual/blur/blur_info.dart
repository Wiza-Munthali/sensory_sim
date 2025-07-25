import 'package:flutter/material.dart';
import 'dart:ui';

class BlurredVisionInfoPage extends StatefulWidget {
  const BlurredVisionInfoPage({super.key});

  @override
  State<BlurredVisionInfoPage> createState() => _BlurredVisionInfoPageState();
}

class _BlurredVisionInfoPageState extends State<BlurredVisionInfoPage> {
  int _selectedType = 0;
  bool _showSimulation = false;

  final List<Map<String, dynamic>> _blurTypes = [
    {
      'name': 'Normal Vision',
      'description': 'Clear vision without blur or visual distortion',
      'prevalence': 'Baseline reference',
    },
    {
      'name': 'Myopia (Nearsightedness)',
      'description': 'Distant objects appear blurry, near objects clear',
      'prevalence': '~30% of adults worldwide',
    },
    {
      'name': 'Hyperopia (Farsightedness)',
      'description': 'Near objects appear blurry, distant objects clearer',
      'prevalence': '~25% of adults',
    },
    {
      'name': 'Cataracts',
      'description': 'Cloudy lens causes overall blurriness and glare',
      'prevalence': '~70% of people over 75',
    },
    {
      'name': 'Astigmatism',
      'description': 'Irregular corneal shape causes distorted, blurry vision',
      'prevalence': '~33% of the population',
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
          'Blurred Vision Education',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
              itemCount: _blurTypes.length,
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
                    width: 180,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _blurTypes[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                isSelected
                                    ? Colors.blue.shade800
                                    : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _blurTypes[index]['prevalence'],
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isSelected
                                    ? Colors.blue.shade600
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
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _blurTypes[_selectedType]['description'],
              style: TextStyle(color: Colors.orange.shade800, fontSize: 14),
            ),
          ),

          // Scenarios
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildScenarioCard(
                  'Reading Text',
                  'How different blur conditions affect text readability',
                  _buildTextDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Distance Vision',
                  'Viewing objects at different distances',
                  _buildDistanceDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Driving Scenario',
                  'Road signs and traffic visibility',
                  _buildDrivingDemo(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Daily Activities',
                  'Common tasks affected by blurred vision',
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

  Widget _buildTextDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTextColumn('Normal Vision', false),
        if (_showSimulation) _buildTextColumn('With Condition', true),
      ],
    );
  }

  Widget _buildTextColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                simulate
                    ? _applyBlurEffect(
                      const Text(
                        'Sample Text\nREADING TEST\n20/20 Vision',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                    : const Text(
                      'Sample Text\nREADING TEST\n20/20 Vision',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDistanceColumn('Normal Vision', false),
        if (_showSimulation) _buildDistanceColumn('With Condition', true),
      ],
    );
  }

  Widget _buildDistanceColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDistanceObject('Near', Colors.green, 24, simulate),
              _buildDistanceObject('Medium', Colors.orange, 18, simulate),
              _buildDistanceObject('Far', Colors.red, 12, simulate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceObject(
    String distance,
    Color color,
    double size,
    bool simulate,
  ) {
    Widget object = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          distance[0],
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    if (simulate) {
      object = _applyDistanceBlur(object, distance);
    }

    return Column(
      children: [
        object,
        const SizedBox(height: 4),
        Text(distance, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildDrivingDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDrivingColumn('Normal Vision', false),
        if (_showSimulation) _buildDrivingColumn('With Condition', true),
      ],
    );
  }

  Widget _buildDrivingColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          simulate ? _applyBlurEffect(_buildRoadSign()) : _buildRoadSign(),
        ],
      ),
    );
  }

  Widget _buildRoadSign() {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Text(
          'EXIT 42\nMain St',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildActivitiesDemo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActivityColumn('Normal Vision', false),
        if (_showSimulation) _buildActivityColumn('With Condition', true),
      ],
    );
  }

  Widget _buildActivityColumn(String label, bool simulate) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Column(
            children: [
              _buildActivityItem('📱 Phone Screen', simulate),
              const SizedBox(height: 8),
              _buildActivityItem('⏰ Clock Face', simulate),
              const SizedBox(height: 8),
              _buildActivityItem('📋 Menu Text', simulate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String item, bool simulate) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(item, style: const TextStyle(fontSize: 14)),
    );

    return simulate ? _applyBlurEffect(content) : content;
  }

  Widget _applyBlurEffect(Widget child) {
    double blurIntensity = _getBlurIntensity();

    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurIntensity,
        sigmaY: blurIntensity,
      ),
      child: child,
    );
  }

  Widget _applyDistanceBlur(Widget child, String distance) {
    double blurIntensity = 0.0;

    switch (_selectedType) {
      case 1: // Myopia - far objects blurry
        blurIntensity =
            distance == 'Far' ? 4.0 : (distance == 'Medium' ? 2.0 : 0.0);
        break;
      case 2: // Hyperopia - near objects blurry
        blurIntensity =
            distance == 'Near' ? 4.0 : (distance == 'Medium' ? 2.0 : 0.0);
        break;
      case 3: // Cataracts - all objects blurry
        blurIntensity = 3.0;
        break;
      case 4: // Astigmatism - distorted vision
        blurIntensity = 2.5;
        break;
    }

    if (blurIntensity == 0.0) return child;

    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blurIntensity,
        sigmaY: blurIntensity,
      ),
      child: child,
    );
  }

  double _getBlurIntensity() {
    switch (_selectedType) {
      case 1: // Myopia
        return 2.0;
      case 2: // Hyperopia
        return 2.0;
      case 3: // Cataracts
        return 3.5;
      case 4: // Astigmatism
        return 2.5;
      default:
        return 0.0;
    }
  }
}
