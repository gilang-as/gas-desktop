import 'package:desktop/screens/splash_screen/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Consolas',
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          onSurface: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(8),
            minimumSize: const Size(0, 40),
            onSurface: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

