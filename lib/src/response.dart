import 'dart:typed_data';

import 'package:http/http.dart' as http;

class Response {
  final http.Response httpResponse;

  Response.fromHttpResponse(this.httpResponse);

  bool get persistentConnection => httpResponse.persistentConnection;

  bool get isRedirect => httpResponse.isRedirect;

  Map<String, String> get headers => httpResponse.headers;

  int get contentLength => httpResponse.contentLength;

  String get reasonPhrase => httpResponse.reasonPhrase;

  int get statusCode => httpResponse.statusCode;

  http.BaseRequest get request => httpResponse.request;

  String get body => httpResponse.body;

  Uint8List get bodyBytes => httpResponse.bodyBytes;
}
