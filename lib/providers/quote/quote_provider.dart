import 'dart:convert';
import 'dart:math';
import 'package:fitness_tracker_app/core/extensions/better_client.dart';
import 'package:fitness_tracker_app/models/quote/quote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'quote_provider.g.dart';

@riverpod
Future<Quote> getQuotes(Ref ref) async {
  final random = Random();
  final client = await ref.getBetterClient();
  final i = random.nextInt(1454) + 1;
  final uri = Uri.parse("https://dummyjson.com/quotes/$i");
  int count = 3;
  while (count > 0) {
    final res = await client.get(uri);
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final quote = Quote.fromJson(body);
      return quote;
    } else {
      await Future.delayed(Duration(seconds: 2));
      count--;
    }
  }
  throw Exception("Failed to load quote");
}
