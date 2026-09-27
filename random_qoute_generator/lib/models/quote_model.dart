class QuoteModel {
  final String text;
  final String author;

  const QuoteModel({required this.text, required this.author});

  static const List<QuoteModel> quotes = [
    QuoteModel(
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
    ),
    QuoteModel(
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
    ),
    QuoteModel(
      text: "In the middle of every difficulty lies opportunity.",
      author: "Albert Einstein",
    ),
    QuoteModel(
      text: "It does not matter how slowly you go as long as you do not stop.",
      author: "Confucius",
    ),
    QuoteModel(
      text: "Believe you can and you're halfway there.",
      author: "Theodore Roosevelt",
    ),
    QuoteModel(
      text: "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
    ),
    QuoteModel(
      text: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
      author: "Winston Churchill",
    ),
    QuoteModel(
      text: "What you get by achieving your goals is not as important as what you become by achieving your goals.",
      author: "Zig Ziglar",
    ),
    QuoteModel(
      text: "Do not wait to strike till the iron is hot, but make it hot by striking.",
      author: "William Butler Yeats",
    ),
    QuoteModel(
      text: "Whether you think you can or you think you can't, you're right.",
      author: "Henry Ford",
    ),
    QuoteModel(
      text: "The best way to predict the future is to create it.",
      author: "Abraham Lincoln",
    ),
    QuoteModel(
      text: "Act as if what you do makes a difference. It does.",
      author: "William James",
    ),
  ];
}