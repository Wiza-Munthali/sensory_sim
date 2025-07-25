import 'dart:math';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'finish.dart';

class DiabeticRetinopathySimulationPage extends StatefulWidget {
  const DiabeticRetinopathySimulationPage({super.key});

  @override
  State<DiabeticRetinopathySimulationPage> createState() =>
      _DiabeticRetinopathySimulationPageState();
}

class _DiabeticRetinopathySimulationPageState
    extends State<DiabeticRetinopathySimulationPage>
    with TickerProviderStateMixin {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;

  int _selectedSeverity = 0;
  bool _showInfo = true;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _severityLevels = [
    {
      'name': 'Normal Vision',
      'description': 'Clear vision without diabetic retinopathy',
      'details':
          'No visual symptoms present. Regular eye exams can detect early changes before symptoms appear.',
    },
    {
      'name': 'Mild NPDR',
      'description': 'Small spots and mild vision changes',
      'details':
          'Microaneurysms and small hemorrhages appear. Vision may be slightly affected but usually not noticeable.',
    },
    {
      'name': 'Moderate NPDR',
      'description': 'More spots, patches, and blurred areas',
      'details':
          'Larger hemorrhages, hard exudates, and cotton wool spots. Central vision may start to blur due to macular edema.',
    },
    {
      'name': 'Proliferative DR (PDR)',
      'description': 'New blood vessels, severe vision loss, and floaters',
      'details':
          'Neovascularization (new fragile blood vessels), extensive hemorrhages, vitreous bleeding causing floaters, and potential retinal detachment.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupCamera();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
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
      setState(() {
        _controller = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _controller == null
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.camera, color: Colors.white, size: 64),
                    SizedBox(height: 16),
                    Text(
                      'Camera not available',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
                        CameraPreview(_controller!),

                        if (_selectedSeverity > 0) _buildVisionEffects(),

                        _buildUI(),
                      ],
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

  Widget _buildUI() {
    return Column(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    LucideIcons.arrowLeft,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Diabetic Retinopathy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 80,
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
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Colors.red.withOpacity(0.8)
                              : Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? Colors.red
                                : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _severityLevels[index]['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            _severityLevels[index]['description'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const Spacer(),

        if (_showInfo)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _severityLevels[_selectedSeverity]['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showInfo = false;
                          });
                        },
                        icon: const Icon(
                          LucideIcons.x,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _severityLevels[_selectedSeverity]['details'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Diabetic retinopathy is the leading cause of blindness in adults. Early detection and blood sugar control can prevent vision loss.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (!_showInfo)
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.red.withOpacity(0.8),
              onPressed: () {
                setState(() {
                  _showInfo = true;
                });
              },
              child: const Icon(LucideIcons.info, color: Colors.white),
            ),
          ),

        // Next button
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FinishPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(LucideIcons.arrowRight, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisionEffects() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            if (_selectedSeverity >= 2)
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _selectedSeverity == 2 ? 3.0 : 6.0,
                  sigmaY: _selectedSeverity == 2 ? 3.0 : 6.0,
                ),
                child: Container(color: Colors.transparent),
              ),

            if (_selectedSeverity == 3)
              ClipPath(
                clipper: _FocalBlurClipper(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Container(color: Colors.transparent),
                ),
              ),

            CustomPaint(
              painter: DiabeticRetinopathyPainter(
                severity: _selectedSeverity,
                animationValue: _animation.value,
              ),
              size: Size.infinite,
            ),
          ],
        );
      },
    );
  }
}

class _FocalBlurClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final random = Random(1);

    for (int i = 0; i < 3; i++) {
      final centerX = size.width * (0.2 + random.nextDouble() * 0.6);
      final centerY = size.height * (0.2 + random.nextDouble() * 0.6);
      final baseRadius = size.width * (0.1 + random.nextDouble() * 0.15);

      path.moveTo(centerX + baseRadius, centerY);

      for (int j = 1; j <= 8; j++) {
        final angle = (j / 8) * 2 * pi;
        final radius = baseRadius * (0.8 + random.nextDouble() * 0.4);
        path.lineTo(
          centerX + cos(angle) * radius,
          centerY + sin(angle) * radius,
        );
      }
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DiabeticRetinopathyPainter extends CustomPainter {
  final int severity;
  final double animationValue;

  DiabeticRetinopathyPainter({
    required this.severity,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (severity == 0) return;

    if (size.width <= 0 ||
        size.height <= 0 ||
        !size.width.isFinite ||
        !size.height.isFinite)
      return;
    if (!animationValue.isFinite) return;

    final random = Random(42);
    final center = Offset(size.width / 2, size.height / 2);

    if (!center.dx.isFinite || !center.dy.isFinite) return;

    try {
      switch (severity) {
        case 1:
          _drawMildSymptoms(canvas, size, center, random);
          break;
        case 2:
          _drawMildSymptoms(canvas, size, center, random);
          _drawModerateSymptoms(canvas, size, center, random);
          break;
        case 3:
          _drawMildSymptoms(canvas, size, center, random);
          _drawModerateSymptoms(canvas, size, center, random);
          _drawSevereSymptoms(canvas, size, center, random);
          break;
      }
    } catch (e) {
      print('Diabetic retinopathy painting error: $e');
    }
  }

  void _drawMildSymptoms(
    Canvas canvas,
    Size size,
    Offset center,
    Random random,
  ) {
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi + random.nextDouble() * 0.5;
      final distance = 80 + random.nextDouble() * 250;
      final spot = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      if (_isOnScreen(spot, size)) {
        _drawMicroaneurysm(canvas, spot, random);
      }
    }

    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      _drawDotHemorrhage(canvas, Offset(x, y), random);
    }
  }

  void _drawModerateSymptoms(
    Canvas canvas,
    Size size,
    Offset center,
    Random random,
  ) {
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi + random.nextDouble() * 1.0;
      final distance = 100 + random.nextDouble() * 200;
      final spot = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      if (_isOnScreen(spot, size)) {
        _drawHardExudate(canvas, spot, random);
      }
    }

    // Larger hemorrhages - blot and flame-shaped
    for (int i = 0; i < 6; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      _drawLargeHemorrhage(canvas, Offset(x, y), random);
    }

    // cotton wool spots - fluffy nerve fiber layer infarcts
    for (int i = 0; i < 4; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      _drawCottonWoolSpot(canvas, Offset(x, y), random);
    }

    // Central vision blur overlay for macular edema
    _drawMacularEdemaBlur(canvas, center, 150, 0.4);
  }

  void _drawSevereSymptoms(
    Canvas canvas,
    Size size,
    Offset center,
    Random random,
  ) {
    // Neovascularization (new blood vessel growth) is the primary cause of PDR
    _drawNeovascularization(canvas, size, center, random);

    // vitreous floaters - semi-transparent shadows
    for (int i = 0; i < 5; i++) {
      _drawRealisticFloater(canvas, size, center, random, i);
    }

    // Large irregular hemorrhages
    for (int i = 0; i < 4; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      _drawSevereHemorrhage(canvas, Offset(x, y), random);
    }

    // Patchy vision loss areas (scotomas)
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.15 + random.nextDouble() * 0.7);
      final y = size.height * (0.15 + random.nextDouble() * 0.7);
      final radius = size.width * (0.08 + random.nextDouble() * 0.12);

      // irregular path for the scotoma
      final path = Path();
      path.moveTo(x + radius, y);
      for (int j = 1; j <= 8; j++) {
        final angle = (j / 8) * 2 * pi;
        final r = radius * (0.7 + random.nextDouble() * 0.5);
        path.lineTo(x + cos(angle) * r, y + sin(angle) * r);
      }
      path.close();

      // a radial gradient to create a dark center with soft, faded edges
      final gradient = RadialGradient(
        colors: [
          Colors.black.withOpacity(0.95),
          Colors.black.withOpacity(0.8),
          Colors.transparent,
        ],
        stops: const [0.3, 0.6, 1.0],
      );

      final paint =
          Paint()
            ..shader = gradient.createShader(
              Rect.fromCircle(center: Offset(x, y), radius: radius),
            );

      canvas.drawPath(path, paint);
    }

    // Severe central vision loss
    _drawMacularEdemaBlur(canvas, center, 200, 0.6);
  }

  bool _isOnScreen(Offset point, Size size) {
    return point.dx >= 0 &&
        point.dx <= size.width &&
        point.dy >= 0 &&
        point.dy <= size.height;
  }

  void _drawMacularEdemaBlur(
    Canvas canvas,
    Offset center,
    double radius,
    double maxOpacity,
  ) {
    final maculaBlur = Paint();
    final maculaGradient = RadialGradient(
      colors: [
        Colors.grey.withOpacity(maxOpacity),
        Colors.grey.withOpacity(maxOpacity * 0.5),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final maculaRect = Rect.fromCircle(center: center, radius: radius);
    maculaBlur.shader = maculaGradient.createShader(maculaRect);
    canvas.drawCircle(center, radius, maculaBlur);
  }

  void _drawNeovascularization(
    Canvas canvas,
    Size size,
    Offset center,
    Random random,
  ) {
    //  fragile blood vessels typical of PDR
    final paint =
        Paint()
          ..color = Colors.red.shade400.withOpacity(0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 0.5);

    // Grow vessels from a few key points
    for (int i = 0; i < 3; i++) {
      final originAngle = random.nextDouble() * 2 * pi;
      final originDist = 40 + random.nextDouble() * 80;
      final origin = Offset(
        center.dx + cos(originAngle) * originDist,
        center.dy + sin(originAngle) * originDist,
      );

      if (!_isOnScreen(origin, size)) continue;

      // tangled web of vessels
      for (int j = 0; j < 5; j++) {
        final path = Path();
        path.moveTo(origin.dx, origin.dy);
        var currentPoint = origin;

        final segmentCount = 3 + random.nextInt(3);
        for (int k = 0; k < segmentCount; k++) {
          final angle = (random.nextDouble() - 0.5) * pi * 1.5;
          final length = 15 + random.nextDouble() * 25;

          final endPoint = Offset(
            currentPoint.dx + cos(angle) * length,
            currentPoint.dy + sin(angle) * length,
          );

          final cp1 = Offset(
            currentPoint.dx + (endPoint.dx - currentPoint.dx) * 0.3,
            currentPoint.dy +
                (endPoint.dy - currentPoint.dy) * 0.3 +
                (random.nextDouble() - 0.5) * 15,
          );

          path.quadraticBezierTo(cp1.dx, cp1.dy, endPoint.dx, endPoint.dy);
          currentPoint = endPoint;
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawRealisticFloater(
    Canvas canvas,
    Size size,
    Offset center,
    Random random,
    int index,
  ) {
    if (size.width <= 0 || size.height <= 0 || !animationValue.isFinite) return;

    final floaterRandom = Random(42 + index * 100);
    final driftSpeed = 0.1 + floaterRandom.nextDouble() * 0.15;
    final driftAngle = floaterRandom.nextDouble() * 2 * pi;

    final baseX = size.width * (0.1 + floaterRandom.nextDouble() * 0.8);
    final baseY = size.height * (0.1 + floaterRandom.nextDouble() * 0.8);

    final driftX = cos(driftAngle) * animationValue * driftSpeed * 50;
    final driftY = sin(driftAngle) * animationValue * driftSpeed * 50;

    final x =
        (baseX + driftX + sin(animationValue * pi * 2 + index) * 10) %
        size.width;
    final y =
        (baseY + driftY + cos(animationValue * pi * 2 + index) * 10) %
        size.height;

    if (!x.isFinite || !y.isFinite) return;

    _drawAmoebaFloater(canvas, Offset(x, y), floaterRandom);
  }

  void _drawAmoebaFloater(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.2 + random.nextDouble() * 0.2)
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            8.0 + random.nextDouble() * 10.0,
          );

    // Irregular amoeba-like shape
    final path = Path();
    final points = 8;
    final baseRadius = 15 + random.nextDouble() * 25;

    for (int i = 0; i < points; i++) {
      final angle = (i / points) * 2 * pi;
      final radiusVariation = 0.5 + random.nextDouble() * 0.8;
      final radius = baseRadius * radiusVariation;

      final pX = center.dx + cos(angle) * radius;
      final pY = center.dy + sin(angle) * radius;

      if (i == 0) {
        path.moveTo(pX, pY);
      } else {
        final prevAngle = ((i - 1) / points) * 2 * pi;
        final prevRadius = baseRadius * (0.5 + random.nextDouble() * 0.8);
        final prevX = center.dx + cos(prevAngle) * prevRadius;
        final prevY = center.dy + sin(prevAngle) * prevRadius;

        final cpX = center.dx + cos(angle - (pi / points)) * radius * 0.8;
        final cpY = center.dy + sin(angle - (pi / points)) * radius * 0.8;

        path.quadraticBezierTo(cpX, cpY, pX, pY);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawMicroaneurysm(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    final radius = 1.5 + random.nextDouble() * 2.0;
    if (radius <= 0 || !radius.isFinite) return;

    final paint =
        Paint()
          ..color = Colors.red.shade900.withOpacity(
            0.6 + random.nextDouble() * 0.2,
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.8);

    canvas.drawCircle(center, radius, paint);
  }

  void _drawDotHemorrhage(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    final radius = 3.0 + random.nextDouble() * 3.0;
    if (radius <= 0 || !radius.isFinite) return;

    final paint =
        Paint()
          ..color = Colors.red.shade800.withOpacity(
            0.6 + random.nextDouble() * 0.25,
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.6);

    // a shape by drawing a few overlapping circles
    for (int i = 0; i < 3; i++) {
      final offsetX = (random.nextDouble() - 0.5) * radius * 0.5;
      final offsetY = (random.nextDouble() - 0.5) * radius * 0.5;
      final subRadius = radius * (0.7 + random.nextDouble() * 0.3);
      canvas.drawCircle(center.translate(offsetX, offsetY), subRadius, paint);
    }
  }

  void _drawHardExudate(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    // Waxy, yellowish lipid deposits with a clumpy, soft appearance.
    final baseSize = 8.0 + random.nextDouble() * 12.0;
    if (baseSize <= 0 || !baseSize.isFinite) return;

    // Build up the exudate with multiple blurred, overlapping layers
    for (int i = 0; i < 8; i++) {
      final offsetX = (random.nextDouble() - 0.5) * baseSize;
      final offsetY = (random.nextDouble() - 0.5) * baseSize;
      final clumpRadius = 2.0 + random.nextDouble() * 5.0;

      final paint =
          Paint()
            ..color = Colors.yellow.shade400.withOpacity(
              0.15 + random.nextDouble() * 0.1,
            )
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, clumpRadius * 0.8);

      canvas.drawCircle(center.translate(offsetX, offsetY), clumpRadius, paint);
    }

    // brighter, more crystalline specs on top
    for (int i = 0; i < 3; i++) {
      final offsetX = (random.nextDouble() - 0.5) * baseSize * 0.6;
      final offsetY = (random.nextDouble() - 0.5) * baseSize * 0.6;
      final specRadius = 1.0 + random.nextDouble() * 1.5;

      final paint =
          Paint()
            ..color = Colors.yellow.shade100.withOpacity(
              0.3 + random.nextDouble() * 0.2,
            )
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, specRadius * 0.5);

      canvas.drawCircle(center.translate(offsetX, offsetY), specRadius, paint);
    }
  }

  void _drawCottonWoolSpot(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    // Fluffy, cloud-like nerve fiber layer infarcts.
    final baseSize = 20.0 + random.nextDouble() * 20.0;
    if (baseSize <= 0 || !baseSize.isFinite) return;

    // multiple large, soft, overlapping circles for a cotton-like texture.
    final mainPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15 + random.nextDouble() * 0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);

    for (int i = 0; i < 10; i++) {
      final offsetX = (random.nextDouble() - 0.5) * baseSize;
      final offsetY = (random.nextDouble() - 0.5) * baseSize;
      final puffRadius = baseSize * (0.3 + random.nextDouble() * 0.4);

      canvas.drawCircle(
        center.translate(offsetX, offsetY),
        puffRadius,
        mainPaint,
      );
    }

    // subtle fibrous texture
    final fiberPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    for (int i = 0; i < 3; i++) {
      final startAngle = random.nextDouble() * 2 * pi;
      final endAngle = startAngle + (random.nextDouble() - 0.5) * pi;
      final length = baseSize * 0.8;

      final path =
          Path()
            ..moveTo(
              center.dx + cos(startAngle) * length * 0.2,
              center.dy + sin(startAngle) * length * 0.2,
            )
            ..quadraticBezierTo(
              center.dx,
              center.dy,
              center.dx + cos(endAngle) * length,
              center.dy + sin(endAngle) * length,
            );
      canvas.drawPath(path, fiberPaint);
    }
  }

  void _drawLargeHemorrhage(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    // Larger, deeper bleeding with more diffuse edges.
    final baseRadius = 8.0 + random.nextDouble() * 10.0;
    if (baseRadius <= 0 || !baseRadius.isFinite) return;

    // blurred circles to create a sense of depth and diffusion.
    final layers = [
      {
        'color': Colors.red.shade900,
        'opacity': 0.3,
        'radius': baseRadius * 1.5,
        'blur': 12.0,
      },
      {
        'color': Colors.red.shade800,
        'opacity': 0.5,
        'radius': baseRadius,
        'blur': 8.0,
      },
      {
        'color': Colors.black.withOpacity(0.2),
        'opacity': 0.7,
        'radius': baseRadius * 0.6,
        'blur': 4.0,
      },
    ];

    for (final layer in layers) {
      final paint =
          Paint()
            ..color = (layer['color'] as Color).withOpacity(
              (layer['opacity'] as double),
            )
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              (layer['blur'] as double),
            );

      canvas.drawCircle(center, (layer['radius'] as double), paint);
    }
  }

  void _drawSevereHemorrhage(Canvas canvas, Offset center, Random random) {
    if (!center.dx.isFinite || !center.dy.isFinite) return;

    // Large, irregular hemorrhage with realistic bleeding patterns
    final baseSize = 20 + random.nextDouble() * 25;
    if (baseSize <= 0 || !baseSize.isFinite) return;

    // multiple layers for realistic bleeding depth
    final layers = [
      Colors.red.shade900.withOpacity(0.8),
      Colors.red.shade800.withOpacity(0.6),
      Colors.red.shade700.withOpacity(0.4),
    ];

    for (int layer = 0; layer < layers.length; layer++) {
      final paint =
          Paint()
            ..color = layers[layer]
            ..style = PaintingStyle.fill;

      final layerSize = baseSize * (1.0 - layer * 0.2);
      final path = Path();
      final points = 12 + random.nextInt(6);

      for (int i = 0; i < points; i++) {
        final angle = (i / points) * 2 * pi;
        final r = layerSize * (0.5 + random.nextDouble() * 0.8);
        final x = center.dx + cos(angle) * r;
        final y = center.dy + sin(angle) * r;

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();

      canvas.drawPath(path, paint);
    }

    // internal texture to simulate blood pooling
    final texturePaint =
        Paint()
          ..color = Colors.red.shade900.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (int i = 0; i < 6; i++) {
      final startAngle = random.nextDouble() * 2 * pi;
      final endAngle = startAngle + (random.nextDouble() - 0.5) * pi;
      final innerRadius = baseSize * 0.3;

      canvas.drawLine(
        Offset(
          center.dx + cos(startAngle) * innerRadius,
          center.dy + sin(startAngle) * innerRadius,
        ),
        Offset(
          center.dx + cos(endAngle) * innerRadius,
          center.dy + sin(endAngle) * innerRadius,
        ),
        texturePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DiabeticRetinopathyPainter oldDelegate) {
    return oldDelegate.severity != severity ||
        oldDelegate.animationValue != animationValue;
  }
}
