import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sensory_sim/auditory/hub.dart';
import 'package:sensory_sim/auditory/muffled.dart';
import 'package:sensory_sim/auditory/tinnitus.dart';
import 'package:sensory_sim/firebase_options.dart';
import 'package:sensory_sim/home.dart';
import 'package:sensory_sim/splash_screen.dart';
import 'package:sensory_sim/visual/blur/intro.dart';
import 'package:sensory_sim/visual/color/intro.dart';
import 'package:sensory_sim/visual/diabetic/intro.dart';
import 'package:sensory_sim/visual/hub.dart';
import 'package:sensory_sim/visual/macular/intro.dart';
import 'package:sensory_sim/visual/tunnel/intro.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const SensorySimHomePage(),
        '/visual': (context) => const VisualDisorderSelectionPage(),
        '/color-blindness': (context) => const ColorBlindnessIntroPage(),
        '/tunnel-vision': (context) => const TunnelVisionIntroPage(),
        '/blurred-vision': (context) => const BlurIntroPage(),
        '/macular-degeneration':
            (context) => const MacularDegenerationIntroPage(),
        '/diabetic-retinopathy':
            (context) => const DiabeticRetinopathyIntroPage(),

        '/auditory': (context) => const AuditoryDisorderSelectionPage(),
        '/muffled-hearing': (context) => const MuffledHearingSimulationPage(),
        '/tinnitus-sim': (context) => const TinnitusSimulationPage(),
      },
    );
  }
}
