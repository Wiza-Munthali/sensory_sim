import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class BlurredVisionSimulationPage extends StatefulWidget {
  const BlurredVisionSimulationPage({super.key});

  @override
  State<BlurredVisionSimulationPage> createState() =>
      _BlurredVisionSimulationPageState();
}

class _BlurredVisionSimulationPageState
    extends State<BlurredVisionSimulationPage> {
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
          'Blurred Vision Simulation',
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
                        // Blurred overlay to simulate vision distortion
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(color: Colors.black.withOpacity(0)),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: _showFunFactsDialog,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Simulating blurred vision caused by cataracts or myopia. Tap to learn more.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
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
                        'Fact About Blurred Vision',
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
    print('Fetching facts about blurred vision...');
    // This function can be used to fetch facts from an API or local database
    final prompt =
        'Blurred vision cause by cataracts or myopia. Provide interesting facts about this condition.';

    final response = await http.post(
      Uri.parse('http://192.168.1.199:8888/facts'),
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
        Uri.parse('http://192.168.1.199:8888/speak'),
        headers: {'Content-Type': 'application/json'},
        // body: '{"text": "$text", "voice": "nova"}',
        body: jsonEncode({
          "text": _facts,
          "voice": "nova",
          "instructions":
              "Speak like you're reassuring a close friend — gentle, sincere, and full of kindness.",
        }),
      );

      if (result.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/blurred_vision_facts.mp3');
        await file.writeAsBytes(result.bodyBytes);
        await _audioPlayer!.setFilePath(file.path);
        print('Audio facts loaded successfully');
      } else {
        print('Failed to fetch audio facts: ${result.body}');
      }
    } else {
      print('Failed to fetch facts: ${response.body}');
    }
  }
}
