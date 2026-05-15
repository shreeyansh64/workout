import 'dart:convert';
import 'dart:math';

import 'package:fitness_tracker_app/models/quote/quote.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'quote_provider.g.dart';

@riverpod
Future<Quote> getQuotes(Ref ref) async{
  final random = Random();
  final i = random.nextInt(1454) + 1;
  final uri = Uri.parse("https://dummyjson.com/quotes/$i");
  final res = await http.get(uri);
  if (res.statusCode == 200) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final quote = Quote.fromJson(body);
    return quote;
  } else {
    throw Exception("Failed to load quote");
  }
}