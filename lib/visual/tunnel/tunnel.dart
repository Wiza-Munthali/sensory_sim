import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'finish.dart';

class TunnelVisionSimulationPage extends StatefulWidget {
  const TunnelVisionSimulationPage({super.key});

  @override
  State<TunnelVisionSimulationPage> createState() =>
      _TunnelVisionSimulationPageState();
}

class _TunnelVisionSimulationPageState
    extends State<TunnelVisionSimulationPage> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _cameras;

  String? _facts;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    getFacts();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _audioPlayer?.dispose();
    _facts = null;
    _audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          'Tunnel Vision Simulation',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:
          _controller == null
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        CameraPreview(_controller!),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return RadialGradient(
                              center: Alignment.center,
                              radius: 0.4,
                              colors: [Colors.transparent, Colors.black],
                              stops: const [0.8, 1.0],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstOut,
                          child: Container(color: Colors.black),
                        ),
                        // Info text
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
                            child: GestureDetector(
                              onTap: _showFunFactsDialog,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'This simulates tunnel vision from conditions like glaucoma or retinitis pigmentosa.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                  MaterialPageRoute(
                                    builder: (context) => const FinishPage(),
                                  ),
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
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
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
                                    Icon(
                                      LucideIcons.arrowRight,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }

  void _showFunFactsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
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
                      Text(
                        'Facts About Tunnel Vision',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        _facts ?? 'Loading facts...',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 1), () async {
      if (_audioPlayer != null) {
        await _audioPlayer!.seek(Duration.zero);
        await _audioPlayer!.play();
      }
    });
  }

  Future<void> getFacts() async {
    print('Fetching facts about tunnel vision...');
    // This function can be used to fetch facts from an API or local database
    try {
      final prompt =
          'Tunnel vision from conditions like glaucoma or retinitis pigmentosa. Provide interesting facts about this condition.';

      final response = await http.post(
        Uri.parse('https://sensory-backend-8xd4.onrender.com/facts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        final facts = jsonDecode(response.body);
        print('Facts fetched successfully: ${facts['output_text']}');
        setState(() {
          _facts = facts['output_text'];
        });

        // Optionally, you can also play an audio file with the facts
        // Get audio from the server
        _audioPlayer = AudioPlayer();

        final result = await http.post(
          Uri.parse('https://sensory-backend-8xd4.onrender.com/speak'),
          headers: {'Content-Type': 'application/json'},
          // body: '{"text": "$text", "voice": "ash"}',
          body: jsonEncode({
            "text": _facts,
            "voice": "ash",
            "instructions":
                "Speak like you're reassuring a close friend — gentle, sincere, and full of kindness.",
          }),
        );

        if (result.statusCode == 200) {
          final dir = await getTemporaryDirectory();
          final file = File('${dir.path}/tunnel_vision_facts.mp3');
          await file.writeAsBytes(result.bodyBytes);
          await _audioPlayer!.setFilePath(file.path);
          print('Audio facts loaded successfully');
        } else {
          print('Failed to fetch audio facts: ${result.body}');
        }
      } else {
        print('Failed to fetch facts: ${response.body}');
      }
    } catch (e) {}
  }
}
