import 'package:flutter/material.dart';
import 'package:innovate/screens/home_page.dart';
import 'package:innovate/screens/onboarding/onboarding_flow.dart';
import 'package:innovate/services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StorageService _storageService = StorageService();
  bool? _onboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final isComplete = await _storageService.isOnboardingComplete();
    setState(() {
      _onboardingComplete = isComplete;
    });
  }

  void _setOnboardingComplete() {
    setState(() {
      _onboardingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innovation Coach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E8B57), // Sea Green
          primary: const Color(0xFF2E8B57),
          secondary: const Color(0xFF66BB6A),
          tertiary: const Color(0xFFA5D6A7),
          background: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E8B57),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Color(0xFF2E8B57)),
        ),
      ),
      home: _onboardingComplete == null
          ? const Center(child: CircularProgressIndicator())
          : _onboardingComplete!
              ? const HomePage(title: 'Innovation Coach')
              : OnboardingFlow(onComplete: _setOnboardingComplete),
    );
  }
}