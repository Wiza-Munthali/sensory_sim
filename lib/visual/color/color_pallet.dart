import 'package:flutter/material.dart';

class ColorBlindnessSimulationPage extends StatefulWidget {
  const ColorBlindnessSimulationPage({super.key});

  @override
  State<ColorBlindnessSimulationPage> createState() =>
      _ColorBlindnessSimulationPageState();
}

class _ColorBlindnessSimulationPageState
    extends State<ColorBlindnessSimulationPage> {
  int _selectedType =
      0; 
  bool _showSimulation = false;

  final List<Map<String, dynamic>> _colorBlindTypes = [
    {
      'name': 'Normal Vision',
      'description': 'How colors appear to people with normal color vision',
      'prevalence': 'Most people',
    },
    {
      'name': 'Deuteranopia',
      'description': 'Difficulty distinguishing red and green (most common)',
      'prevalence': '~5% of men, 0.4% of women',
    },
    {
      'name': 'Protanopia',
      'description': 'Reduced sensitivity to red light',
      'prevalence': '~2% of men, 0.02% of women',
    },
    {
      'name': 'Tritanopia',
      'description': 'Difficulty distinguishing blue and yellow (rare)',
      'prevalence': '~0.008% of people',
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
          'Color Blindness Simulation',
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
         
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _colorBlindTypes.length,
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
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _colorBlindTypes[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                isSelected
                                    ? Colors.teal.shade800
                                    : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _colorBlindTypes[index]['prevalence'],
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isSelected
                                    ? Colors.teal.shade600
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

         
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _colorBlindTypes[_selectedType]['description'],
              style: TextStyle(color: Colors.blue.shade800, fontSize: 14),
            ),
          ),

         
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildScenarioCard(
                  'Traffic Light',
                  'Can you identify which light is on?',
                  _buildTrafficLight(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Color Chart',
                  'Distinguishing colors in data visualization',
                  _buildColorChart(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'Nature Scene',
                  'How autumn colors appear',
                  _buildNatureScene(),
                ),
                const SizedBox(height: 20),
                _buildScenarioCard(
                  'UI Elements',
                  'Success, warning, and error indicators',
                  _buildUIElements(),
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

  Widget _buildTrafficLight() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTrafficLightColumn('Normal Vision', false),
        if (_showSimulation) _buildTrafficLightColumn('Simulated Vision', true),
      ],
    );
  }

  Widget _buildTrafficLightColumn(String label, bool simulate) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrafficLightBulb(Colors.red, simulate),
              _buildTrafficLightBulb(Colors.yellow, simulate),
              _buildTrafficLightBulb(Colors.green, simulate, isOn: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrafficLightBulb(
    Color normalColor,
    bool simulate, {
    bool isOn = false,
  }) {
    Color displayColor = normalColor;

    if (simulate && isOn) {
      displayColor = _simulateColorBlindness(normalColor);
    }

    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isOn ? displayColor : Colors.grey.shade800,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildColorChart() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!_showSimulation) _buildChartColumn('Colors', false),
            if (_showSimulation) ...[
              _buildChartColumn('Normal', false),
              _buildChartColumn('Simulated', true),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildChartColumn(String label, bool simulate) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];

    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        ...colors.map((color) {
          Color displayColor =
              simulate ? _simulateColorBlindness(color) : color;
          return Container(
            width: 80,
            height: 25,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: displayColor,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNatureScene() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLeafGroup('Normal Vision', false),
        if (_showSimulation) _buildLeafGroup('Simulated Vision', true),
      ],
    );
  }

  Widget _buildLeafGroup(String label, bool simulate) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLeaf(Colors.green.shade700, simulate),
            _buildLeaf(Colors.yellow.shade700, simulate),
            _buildLeaf(Colors.red.shade700, simulate),
            _buildLeaf(Colors.orange.shade700, simulate),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaf(Color normalColor, bool simulate) {
    Color displayColor =
        simulate ? _simulateColorBlindness(normalColor) : normalColor;

    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
    );
  }

  Widget _buildUIElements() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildUIColumn('Normal Vision', false),
        if (_showSimulation) _buildUIColumn('Simulated Vision', true),
      ],
    );
  }

  Widget _buildUIColumn(String label, bool simulate) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        _buildUIButton('Success', Colors.green, simulate),
        const SizedBox(height: 8),
        _buildUIButton('Warning', Colors.orange, simulate),
        const SizedBox(height: 8),
        _buildUIButton('Error', Colors.red, simulate),
      ],
    );
  }

  Widget _buildUIButton(String text, Color normalColor, bool simulate) {
    Color displayColor =
        simulate ? _simulateColorBlindness(normalColor) : normalColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _simulateColorBlindness(Color originalColor) {
    switch (_selectedType) {
      case 1: 
        return _simulateDeuteranopia(originalColor);
      case 2: 
        return _simulateProtanopia(originalColor);
      case 3: 
        return _simulateTritanopia(originalColor);
      default:
        return originalColor;
    }
  }

  Color _simulateDeuteranopia(Color color) {
    
    final r = color.red;
    final g = (color.green * 0.3).round();
    final b = color.blue;

    return Color.fromARGB(color.alpha, r, g, b);
  }

  Color _simulateProtanopia(Color color) {
    
    final r = (color.red * 0.2).round();
    final g = color.green;
    final b = color.blue;

    return Color.fromARGB(color.alpha, r, g, b);
  }

  Color _simulateTritanopia(Color color) {
    
    final r = color.red;
    final g = color.green;
    final b = (color.blue * 0.3).round();

    return Color.fromARGB(color.alpha, r, g, b);
  }
}