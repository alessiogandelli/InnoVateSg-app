import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: const HomePage(title: 'Innovation Coach'),
    );
  }
}