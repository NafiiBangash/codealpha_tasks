import 'package:flashcard_quiz_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'models/flashcard_model.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF4F6EF7);

    return MaterialApp(
      title: 'Flashcard Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF5F6FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black87,
          centerTitle: true,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: const Color(0xFF1C1B29),
              displayColor: const Color(0xFF1C1B29),
            ),
      ),
      home: const HomePage(),
    );
  }
}

