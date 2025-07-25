import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class TinnitusSimulationPage extends StatefulWidget {
  const TinnitusSimulationPage({super.key});

  @override
  State<TinnitusSimulationPage> createState() => _TinnitusSimulationPageState();
}

class _TinnitusSimulationPageState extends State<TinnitusSimulationPage> {
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

    _controller = VideoPlayerController.asset('assets/Tinitus.mp4')
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

  Future<void> playTinnitusAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
    }

    try {
      await _audioPlayer.setAsset('assets/tinnitus_simulation_30s.wav');
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      print('Error playing tinnitus audio: $e');
    }
  }

  Future<void> getFacts() async {
    try {
      const prompt =
          'Tinnitus. Provide concise and interesting facts about this auditory condition.';

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
            "voice": "ash",
            "instructions":
                "Use a calm, thoughtful tone as if guiding someone through a personal experience.",
          }),
        );

        if (ttsResponse.statusCode == 200) {
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/tinnitus_facts.mp3');
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
                        'Fact About Tinnitus',
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
            duration: const Duration(milliseconds: 300),
            child:
                hideElements
                    ? const SizedBox.shrink()
                    : Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Experience',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: playTinnitusAudio,
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFAD0C4),
                                    Color(0xFFFFD1FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.graphic_eq_rounded,
                                    size: 48,
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Play Tinnitus Simulation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to hear the high-pitched ringing that simulates this condition.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
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
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
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
                            'Simulating tinnitus — a persistent phantom ringing. Tap to learn more.',
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

                Text(
                  'Tinnitus Simulation',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: !hideElements ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      hideElements = false;
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
