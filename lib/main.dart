import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensory_sim/auditory/hub.dart';
import 'package:sensory_sim/auditory/muffled.dart';
import 'package:sensory_sim/auditory/tinnitus.dart';
import 'package:sensory_sim/firebase_options.dart';
import 'package:sensory_sim/home.dart';
import 'package:sensory_sim/visual/blur.dart';
import 'package:sensory_sim/visual/color/intro.dart';
import 'package:sensory_sim/visual/diabetic_retinopathy.dart';
import 'package:sensory_sim/visual/hub.dart';
import 'package:sensory_sim/visual/macular.dart';
import 'package:sensory_sim/visual/tunnel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();

  runApp(const MainApp());
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        '/color-blindness': (context) => const ColorBlindnessIntroPage(),
        '/tunnel-vision': (context) => const TunnelVisionSimulationPage(),
        '/blurred-vision': (context) => const BlurredVisionSimulationPage(),
        '/macular-degeneration':
            (context) => const MacularDegenerationSimulationPage(),
        '/diabetic-retinopathy':
            (context) => const DiabeticRetinopathySimulationPage(),

        '/auditory': (context) => const AuditoryDisorderSelectionPage(),
        '/muffled-hearing': (context) => const MuffledHearingSimulationPage(),
        '/tinnitus-sim': (context) => const TinnitusSimulationPage(),
        // You can add auditory and sensory overload routes similarly later.
      },
    );
  }
}
