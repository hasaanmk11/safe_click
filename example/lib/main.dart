import 'package:flutter/material.dart';
import 'package:safe_click/safe_click.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("SafeClick Example")),
        body: Center(
          child: SafeClick(
            cooldown: const Duration(seconds: 2),
            onTap: () {
              print("Clicked safely!");
            },
            child: ElevatedButton(
              onPressed: () {}, // Leave empty; SafeClick handles taps
              child: const Text("Click Me"),
            ),
          ),
        ),
      ),
    );
  }
}
