import 'package:flutter/material.dart';
import 'package:sensory_sim/home.dart';
import 'package:sensory_sim/visual/blur.dart';
import 'package:sensory_sim/visual/color.dart';
import 'package:sensory_sim/visual/hub.dart';
import 'package:sensory_sim/visual/tunnel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SensorySim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SensorySimHomePage(),
        '/visual': (context) => const VisualDisorderSelectionPage(),
        '/color-blindness': (context) => const ColorBlindnessSimulationPage(),
        '/tunnel-vision': (context) => const TunnelVisionSimulationPage(),
        '/blurred-vision': (context) => const BlurredVisionSimulationPage(),
        // You can add auditory and sensory overload routes similarly later.
      },
    );
  }
}
