import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MuffledHearingSimulationPage extends StatefulWidget {
  const MuffledHearingSimulationPage({super.key});

  @override
  State<MuffledHearingSimulationPage> createState() =>
      _MuffledHearingSimulationPageState();
}

class _MuffledHearingSimulationPageState
    extends State<MuffledHearingSimulationPage> {
  late AudioPlayer _audioPlayer;
  late AudioPlayer _factAudioPlayer;
  String? _facts;
  bool _isPlaying = false;

  late VideoPlayerController _controller;

  bool hideElements = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _factAudioPlayer = AudioPlayer();
    _controller = VideoPlayerController.asset('assets/muffled_hearing.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    getFacts();

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.play();
    });

    _controller.addListener(() {
      if (_controller.value.isInitialized && _controller.value.isCompleted) {
        if (mounted) {
          setState(() {
            hideElements = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _factAudioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> playSimulation(String level) async {
    if (_isPlaying) await _audioPlayer.stop();

    final assetPath = switch (level) {
      'normal' => 'assets/normal.mp3',
      'moderate' => 'assets/moderate_muffled.mp3',
      'severe' => 'assets/severe_muffled.mp3',
      _ => 'assets/normal.mp3',
    };

    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> getFacts() async {
    try {
      final prompt =
          'Muffled hearing or conductive hearing loss. Provide interesting facts about this condition.';

      final response = await http.post(
        Uri.parse('https://sensory-backend-8xd4.onrender.com/facts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        final facts = jsonDecode(response.body);
        _facts = facts['output_text'];

        final ttsResponse = await http.post(
          Uri.parse('https://sensory-backend-8xd4.onrender.com/speak'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "text": _facts,
            "voice": "nova",
            "instructions":
                "Speak calmly like you're helping someone understand a new experience for the first time.",
          }),
        );

        if (ttsResponse.statusCode == 200) {
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/muffled_facts.mp3');
          await file.writeAsBytes(ttsResponse.bodyBytes);
          await _factAudioPlayer.setFilePath(file.path);
        }
      }
    } catch (e) {}
  }

  void _showFunFactsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Fact About Muffled Hearing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _facts ?? 'Loading facts...',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    Future.delayed(const Duration(milliseconds: 800), () async {
      await _factAudioPlayer.seek(Duration.zero);
      await _factAudioPlayer.play();
    });
  }

  Widget _buildAudioCard({
    required String level,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => playSimulation(level),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.hearing, color: Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child:
                _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : const SizedBox.shrink(),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child:
                hideElements
                    ? const SizedBox.shrink()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Experience",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildAudioCard(
                          level: 'normal',
                          label: 'Normal Hearing',
                          color: const Color.fromARGB(255, 35, 129, 222),
                        ),
                        _buildAudioCard(
                          level: 'moderate',
                          label: 'Moderate Muffled Hearing',
                          color: const Color.fromARGB(255, 76, 89, 118),
                        ),
                        _buildAudioCard(
                          level: 'severe',
                          label: 'Severe Muffled Hearing',
                          color: const Color.fromARGB(255, 33, 36, 40),
                        ),

                        const SizedBox(height: 60),

                        IconButton(
                          onPressed: () {
                            _controller.seekTo(Duration.zero);
                            _controller.play();
                            setState(() {
                              hideElements = true;
                            });
                          },
                          icon: Icon(
                            Icons.replay_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const Text(
                          'Replay',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                hideElements
                    ? const SizedBox.shrink()
                    : Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: _showFunFactsDialog,
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Simulating muffled hearing or conductive hearing loss. Tap to learn more.',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
          ),

          Positioned(
            top: 56,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),

                Flexible(
                  child: Text(
                    'Muffled Hearing Simulation',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.black,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const Icon(Icons.home_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
