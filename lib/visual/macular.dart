import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MacularDegenerationSimulationPage extends StatefulWidget {
  const MacularDegenerationSimulationPage({super.key});

  @override
  State<MacularDegenerationSimulationPage> createState() =>
      _MacularDegenerationSimulationPageState();
}

class _MacularDegenerationSimulationPageState
    extends State<MacularDegenerationSimulationPage> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;

  int _selectedSeverity =
      0; // 0: Normal, 1: Early, 2: Intermediate, 3: Advanced
  bool _showInfo = true;

  final List<Map<String, dynamic>> _severityLevels = [
    {
      'name': 'Normal Vision',
      'description': 'How vision appears without macular degeneration',
      'details': 'Clear central vision with no blind spots or distortion',
    },
    {
      'name': 'Early Stage',
      'description': 'Slight blurring and difficulty with fine details',
      'details': 'Small drusen (deposits) may cause minimal visual changes',
    },
    {
      'name': 'Intermediate Stage',
      'description': 'Noticeable central vision problems and dark spots',
      'details': 'Larger drusen and possible pigmentary changes',
    },
    {
      'name': 'Advanced Stage',
      'description': 'Significant central vision loss with large blind spots',
      'details': 'Geographic atrophy or neovascular complications',
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        _initializeControllerFuture = _controller!.initialize();
        setState(() {});
      }
    } catch (e) {
      // Handle camera initialization error
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        title: const Text(
          'Macular Degeneration',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showInfo = !_showInfo;
              });
            },
            icon: Icon(_showInfo ? Icons.visibility_off : Icons.info_outline),
          ),
        ],
      ),
      body:
          _controller == null
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Setting up camera...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Camera preview
                        CameraPreview(_controller!),

                        // Macular degeneration overlay
                        _buildMacularOverlay(),

                        // Severity selector at top
                        _buildSeveritySelector(),

                        // Information panel
                        if (_showInfo) _buildInfoPanel(),

                        // Educational content at bottom
                        _buildEducationalContent(),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Camera error. Please check permissions.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                },
              ),
    );
  }

  Widget _buildMacularOverlay() {
    return CustomPaint(
      painter: MacularDegenerationPainter(_selectedSeverity),
      size: Size.infinite,
    );
  }

  Widget _buildSeveritySelector() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _severityLevels.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedSeverity == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSeverity = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.teal.withOpacity(0.9)
                          : Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.teal : Colors.white54,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _severityLevels[index]['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _severityLevels[_selectedSeverity]['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _severityLevels[_selectedSeverity]['description'],
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              _severityLevels[_selectedSeverity]['details'],
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalContent() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Text(
                  'About Macular Degeneration',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Age-related macular degeneration (AMD) affects the center of the retina, causing central vision problems while peripheral vision remains intact.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // _buildFactCard('11M+', 'Americans affected'),
                // _buildFactCard('50+', 'Typical onset age'),
                // _buildFactCard('#1', 'Cause of vision loss'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFactCard(String number, String description) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: Colors.teal.withOpacity(0.2),
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.teal.withOpacity(0.5)),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           number,
  //           style: const TextStyle(
  //             color: Colors.teal,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 14,
  //           ),
  //         ),
  //         Text(
  //           description,
  //           style: const TextStyle(color: Colors.white70, fontSize: 10),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class MacularDegenerationPainter extends CustomPainter {
  final int severity;

  MacularDegenerationPainter(this.severity);

  @override
  void paint(Canvas canvas, Size size) {
    if (severity == 0) return; // Normal vision - no overlay

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();

    switch (severity) {
      case 1: // Early stage
        _paintEarlyStage(canvas, size, center, paint);
        break;
      case 2: // Intermediate stage
        _paintIntermediateStage(canvas, size, center, paint);
        break;
      case 3: // Advanced stage
        _paintAdvancedStage(canvas, size, center, paint);
        break;
    }
  }

  void _paintEarlyStage(Canvas canvas, Size size, Offset center, Paint paint) {
    // Slight blur in central area
    final blurRadius = min(size.width, size.height) * 0.15;

    // Create subtle drusen-like spots
    final random = Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final distance =
          blurRadius * 0.3 + random.nextDouble() * blurRadius * 0.4;
      final spot = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      paint.color = Colors.yellow.withOpacity(0.1);
      canvas.drawCircle(spot, 3 + random.nextDouble() * 4, paint);
    }

    // Very light central blur
    paint.color = Colors.black.withOpacity(0.05);
    canvas.drawCircle(center, blurRadius, paint);
  }

  void _paintIntermediateStage(
    Canvas canvas,
    Size size,
    Offset center,
    Paint paint,
  ) {
    final centralRadius = min(size.width, size.height) * 0.2;

    // More prominent drusen pattern
    final random = Random(42);
    for (int i = 0; i < 15; i++) {
      final angle = (i / 15) * 2 * pi + random.nextDouble() * 0.5;
      final distance =
          centralRadius * 0.2 + random.nextDouble() * centralRadius * 0.6;
      final spot = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      paint.color = Colors.yellow.withOpacity(0.15 + random.nextDouble() * 0.1);
      canvas.drawCircle(spot, 2 + random.nextDouble() * 6, paint);
    }

    // Central dark spot with gradual fade
    final gradient = RadialGradient(
      colors: [
        Colors.black.withOpacity(0.4),
        Colors.black.withOpacity(0.2),
        Colors.transparent,
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final rect = Rect.fromCircle(center: center, radius: centralRadius);
    paint.shader = gradient.createShader(rect);
    canvas.drawCircle(center, centralRadius, paint);
    paint.shader = null;

    // Add some wavy distortion effect
    _paintDistortion(canvas, size, center, paint, centralRadius * 0.8);
  }

  void _paintAdvancedStage(
    Canvas canvas,
    Size size,
    Offset center,
    Paint paint,
  ) {
    final centralRadius = min(size.width, size.height) * 0.25;

    // Large central scotoma (blind spot)
    final gradient = RadialGradient(
      colors: [
        Colors.black.withOpacity(0.9),
        Colors.black.withOpacity(0.6),
        Colors.black.withOpacity(0.3),
        Colors.transparent,
      ],
      stops: const [0.0, 0.4, 0.7, 1.0],
    );

    final rect = Rect.fromCircle(center: center, radius: centralRadius);
    paint.shader = gradient.createShader(rect);
    canvas.drawCircle(center, centralRadius, paint);
    paint.shader = null;

    // Additional smaller scotomas around the main one
    final random = Random(42);
    for (int i = 0; i < 6; i++) {
      final angle = (i / 6) * 2 * pi;
      final distance =
          centralRadius * 1.2 + random.nextDouble() * centralRadius * 0.5;
      final spot = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      paint.color = Colors.black.withOpacity(0.3 + random.nextDouble() * 0.4);
      canvas.drawCircle(spot, 15 + random.nextDouble() * 20, paint);
    }

    // Heavy distortion
    _paintDistortion(canvas, size, center, paint, centralRadius * 1.2);

    // Metamorphopsia (wavy lines) effect
    _paintMetamorphopsia(canvas, size, center, paint);
  }

  void _paintDistortion(
    Canvas canvas,
    Size size,
    Offset center,
    Paint paint,
    double radius,
  ) {
    paint.color = Colors.white.withOpacity(0.1);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Create wavy distortion lines
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final path = Path();

      for (double t = 0; t <= 1; t += 0.1) {
        final distance = radius * t;
        final waveOffset = sin(t * 4 * pi) * 5;
        final x =
            center.dx +
            cos(angle) * distance +
            cos(angle + pi / 2) * waveOffset;
        final y =
            center.dy +
            sin(angle) * distance +
            sin(angle + pi / 2) * waveOffset;

        if (t == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  void _paintMetamorphopsia(
    Canvas canvas,
    Size size,
    Offset center,
    Paint paint,
  ) {
    paint.color = Colors.grey.withOpacity(0.15);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    // Grid distortion to show metamorphopsia
    final gridSize = 20.0;
    final distortionRadius = min(size.width, size.height) * 0.3;

    for (double x = 0; x < size.width; x += gridSize) {
      final path = Path();
      for (double y = 0; y < size.height; y += 2) {
        final distance = sqrt(pow(x - center.dx, 2) + pow(y - center.dy, 2));
        double offsetX = x;

        if (distance < distortionRadius) {
          final distortionFactor =
              (distortionRadius - distance) / distortionRadius;
          offsetX += sin(y * 0.1) * 8 * distortionFactor;
        }

        if (y == 0) {
          path.moveTo(offsetX, y);
        } else {
          path.lineTo(offsetX, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      final path = Path();
      for (double x = 0; x < size.width; x += 2) {
        final distance = sqrt(pow(x - center.dx, 2) + pow(y - center.dy, 2));
        double offsetY = y;

        if (distance < distortionRadius) {
          final distortionFactor =
              (distortionRadius - distance) / distortionRadius;
          offsetY += sin(x * 0.1) * 8 * distortionFactor;
        }

        if (x == 0) {
          path.moveTo(x, offsetY);
        } else {
          path.lineTo(x, offsetY);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(MacularDegenerationPainter oldDelegate) {
    return oldDelegate.severity != severity;
  }
}
