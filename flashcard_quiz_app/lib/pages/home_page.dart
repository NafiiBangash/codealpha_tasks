import 'package:flutter/material.dart';
import '../models/flashcard_model.dart';
import '../widgets/empty_state.dart';
import '../widgets/flashcardview.dart';
import 'card_editor_sheet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Starter deck so the app isn't empty on first launch.
  final List<FlashcardModel> _cards = [
    FlashcardModel(
      question: 'What is the capital of France?',
      answer: 'Paris',
    ),
    FlashcardModel(
      question: 'What is 12 x 8?',
      answer: '96',
    ),
    FlashcardModel(
      question: 'Who wrote "Romeo and Juliet"?',
      answer: 'William Shakespeare',
    ),
  ];

  int _currentIndex = 0;
  bool _showAnswer = false;

  FlashcardModel? get _currentCard =>
      _cards.isEmpty ? null : _cards[_currentIndex];

  void _goToNext() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _cards.length;
      _showAnswer = false;
    });
  }

  void _goToPrevious() {
    if (_cards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _cards.length) % _cards.length;
      _showAnswer = false;
    });
  }

  void _toggleShowAnswer() {
    setState(() => _showAnswer = !_showAnswer);
  }

  Future<void> _openCardEditor({FlashcardModel? existing}) async {
    final result = await showModalBottomSheet<FlashcardModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardEditorSheet(existing: existing),
    );

    if (result == null) return;

    setState(() {
      if (existing == null) {
        // Adding a new card.
        _cards.add(result);
        _currentIndex = _cards.length - 1;
      } else {
        // Editing the card currently shown.
        final index = _cards.indexOf(existing);
        if (index != -1) {
          _cards[index] = result;
        }
      }
      _showAnswer = false;
    });
  }

  Future<void> _deleteCurrentCard() async {
    final card = _currentCard;
    if (card == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete flashcard?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _cards.remove(card);
      if (_cards.isEmpty) {
        _currentIndex = 0;
      } else if (_currentIndex >= _cards.length) {
        _currentIndex = _cards.length - 1;
      }
      _showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _currentCard;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcard Quiz',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (card != null)
            IconButton(
              tooltip: 'Edit card',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _openCardEditor(existing: card),
            ),
          if (card != null)
            IconButton(
              tooltip: 'Delete card',
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteCurrentCard,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              if (_cards.isNotEmpty)
                Text(
                  'Card ${_currentIndex + 1} of ${_cards.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: card == null
                      ? EmptyState(onAdd: () => _openCardEditor())
                      : FlashcardView(
                    card: card,
                    showAnswer: _showAnswer,
                    onTap: _toggleShowAnswer,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (card != null) ...[
                FilledButton.icon(
                  onPressed: _toggleShowAnswer,
                  icon: Icon(_showAnswer
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  label: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _cards.length > 1 ? _goToPrevious : null,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _cards.length > 1 ? _goToNext : null,
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text('Next'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCardEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
      ),
    );
  }
}