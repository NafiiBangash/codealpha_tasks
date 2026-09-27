import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
class FlashcardView extends StatelessWidget {
  const FlashcardView({super.key,
    required this.card,
    required this.showAnswer,
    required this.onTap,
  });

  final FlashcardModel card;
  final bool showAnswer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: Container(
          key: ValueKey('${card.question}-$showAnswer'),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 260),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: showAnswer
                ? const Color(0xFF4F6EF7)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: (showAnswer
                    ? const Color(0xFF4F6EF7)
                    : Colors.black)
                    .withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                showAnswer ? 'ANSWER' : 'QUESTION',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: showAnswer
                      ? Colors.white70
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                showAnswer ? card.answer : card.question,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: showAnswer ? Colors.white : const Color(0xFF1C1B29),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Tap card to flip',
                style: TextStyle(
                  fontSize: 12,
                  color: showAnswer ? Colors.white60 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}