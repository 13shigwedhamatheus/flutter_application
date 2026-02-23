import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer

void main() {
  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusFlow Timer',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark theme for a focus app
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E), // Dark background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent app bar
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 72),
          bodyLarge: TextStyle(color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent.shade700, // Bright accent color
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
        ),
      ),
      home: const FocusFlowTimerScreen(),
    );
  }
}

class FocusFlowTimerScreen extends StatefulWidget {
  const FocusFlowTimerScreen({super.key});

  @override
  State<FocusFlowTimerScreen> createState() => _FocusFlowTimerScreenState();
}

class _FocusFlowTimerScreenState extends State<FocusFlowTimerScreen> {
  static const int _initialDuration = 25 * 60; // 25 minutes in seconds
  int _currentDuration = _initialDuration;
  Timer? _timer;
  bool _isRunning = false;

  String get _timerDisplay {
    int minutes = _currentDuration ~/ 60;
    int seconds = _currentDuration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    if (_isRunning) return; // Prevent starting if already running
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentDuration > 0) {
          _currentDuration--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          // Optionally, add a notification or sound here
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _currentDuration = _initialDuration;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important: Cancel timer when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusFlow Timer'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: _currentDuration / _initialDuration,
                    strokeWidth: 10,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.cyanAccent.shade400, // Progress color
                    ),
                  ),
                ),
                Text(
                  _timerDisplay,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  onPressed: _isRunning ? _pauseTimer : null, // Only enabled if running
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  icon: Icon(_isRunning ? Icons.play_arrow_outlined : Icons.play_arrow),
                  label: Text(_isRunning ? 'Running' : 'Start'),
                  onPressed: _isRunning ? null : _startTimer, // Only enabled if not running
                ),
                const SizedBox(width: 20),
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  onPressed: _resetTimer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}