import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _factAudioPlayer = AudioPlayer();
    getFacts();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _factAudioPlayer.dispose();
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
    const prompt = 'Tinnitus. Provide concise and interesting facts about this auditory condition.';

    final response = await http.post(
      Uri.parse('http://192.168.1.199:8888/facts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"prompt": prompt}),
    );

    if (response.statusCode == 200) {
      final facts = jsonDecode(response.body);
      _facts = facts['output_text'];

      final ttsResponse = await http.post(
        Uri.parse('http://192.168.1.199:8888/speak'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "text": _facts,
          "voice": "nova",
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
  }

  void _showFunFactsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _facts ?? 'Loading facts...',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
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
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Tinnitus Simulation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: playTinnitusAudio,
              child: Container(
                padding: const EdgeInsets.all(28),
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFAD0C4), Color(0xFFFAD0C4)],
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
                  children: const [
                    Icon(Icons.graphic_eq_rounded, size: 48, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Play Tinnitus Simulation',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap to hear the high-pitched ringing that simulates this condition.',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
