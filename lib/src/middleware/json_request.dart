import 'dart:convert';

import '../request.dart';

void JsonRequestMiddleware(Request request) {
  request.headers['content-type'] = 'application/json;charset=utf-8';
  if (request.body != null && (request.body is Map || request.body is List)) {
    request.body = jsonEncode(request.body);
  }
}
