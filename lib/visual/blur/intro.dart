import 'package:flutter/material.dart';
import 'package:sensory_sim/visual/blur/blur.dart';
import 'package:sensory_sim/visual/blur/blur_info.dart';
import 'package:video_player/video_player.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BlurIntroPage extends StatefulWidget {
  const BlurIntroPage({super.key});

  @override
  State<BlurIntroPage> createState() => _BlurIntroPageState();
}

class _BlurIntroPageState extends State<BlurIntroPage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _videoFinished = false;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset('assets/blur_vision.mp4');
      await _controller.initialize();
      _controller.setLooping(false);
      _controller.setVolume(1.0);

      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration &&
            _controller.value.duration > Duration.zero &&
            !_isRestarting) {
          setState(() {
            _videoFinished = true;
          });
        }
      });

      setState(() {
        _isVideoInitialized = true;
      });
      _controller.play();
    } catch (e) {
      setState(() {
        _isVideoInitialized = false;
        _videoFinished = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
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
          'Blurred Vision',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_isVideoInitialized && !_videoFinished)
            Container(
              margin: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _videoFinished = true;
                    _controller.seekTo(_controller.value.duration);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isVideoInitialized)
            VideoPlayer(_controller)
          else
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA9D6E5), Color(0xFFCFE0E8)],
                ),
              ),
              child: Container(),
            ),

          // Overlay content when video finishes
          if (_videoFinished)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Experience Blurred Vision',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose Your Experience',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Live Simulation Button
                      _buildSimulationCard(
                        icon: LucideIcons.camera,
                        title: 'Live Blur Simulation',
                        description:
                            'See the world as if you have blurred vision, simulating conditions like cataracts or uncorrected refractive error.',
                        gradientColors: const [
                          Color(0xFFC9F7EB),
                          Color(0xFF97E3D5),
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const BlurredVisionSimulationPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Interactive Examples Button
                      _buildSimulationCard(
                        icon: LucideIcons.palette,
                        title: 'Interactive Blur Examples',
                        description:
                            'Learn about blurred vision and discover how it affects daily life and accessibility.',
                        gradientColors: const [
                          Color(0xFFDFC7F5),
                          Color(0xFFDFC7F5),
                        ],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const BlurredVisionInfoPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Restart Button
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isRestarting = true;
                            _videoFinished = false;
                          });
                          await Future.delayed(
                            const Duration(milliseconds: 100),
                          );
                          await _controller.seekTo(Duration.zero);
                          await _controller.play();
                          await Future.delayed(
                            const Duration(milliseconds: 200),
                          );
                          setState(() {
                            _isRestarting = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.rotateCcw,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimulationCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }
}
