import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

extension DebounceAndCancel on Ref {
  Future<http.Client> getBetterClient() async {
    bool disposed = false;
    final client = http.Client();
    onDispose(() {
      disposed = true;
      client.close();
    });
    if (disposed) {
      throw Exception("Client is disposed");
    }

    //Debouce for 2 seconds.
    await Future.delayed(Duration(seconds: 2));
    return client;
  }
}
