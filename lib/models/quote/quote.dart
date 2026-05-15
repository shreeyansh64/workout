class Quote {
  final int id;
  final String quote;
  final String author;

  Quote({
    required this.quote,
    required this.author, required this.id,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(id: json['id'] ,quote: json['quote'], author: json['author']);
  }
}
