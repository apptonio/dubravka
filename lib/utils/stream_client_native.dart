import 'package:dubravka/utils/stream_client.dart';
import 'package:http/http.dart' as http;

class StreamClientNative extends StreamClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return http.Client().send(request);
  }
}

StreamClient getClient() => StreamClientNative();