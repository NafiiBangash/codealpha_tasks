import 'dart:math';
import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();
  late QuoteModel _currentQuote;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final List<QuoteModel> _quotes = QuoteModel.quotes;

  @override
  void initState() {
    super.initState();
    _currentQuote = _pickNewQuote();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  QuoteModel _pickNewQuote() {
    if (_quotes.length == 1) return _quotes.first;
    QuoteModel next;
    do {
      next = _quotes[_random.nextInt(_quotes.length)];
    } while (next.text == (_currentQuoteSafe?.text));
    return next;
  }

  QuoteModel? get _currentQuoteSafe {
    try {
      return _currentQuote;
    } catch (_) {
      return null;
    }
  }

  void _showNewQuote() {
    _controller.reverse().then((_) {
      setState(() {
        _currentQuote = _pickNewQuote();
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.format_quote_rounded,
                size: 56,
                color: colorScheme.primary.withOpacity(0.6),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      _currentQuote.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: Color(0xFF2B2B33),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "— ${_currentQuote.author}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _showNewQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "New Quote",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
