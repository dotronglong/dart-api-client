import 'dart:convert';

import 'package:test/test.dart';

import 'package:api_client/api_client.dart';

void main() {
  test('JsonRequestMiddleware: empty body', () {
    Request request = Request("http://dommain.com", Method.POST);
    JsonRequestMiddleware(request);
    expect(request.headers['content-type'], 'application/json;charset=utf-8');
    expect(request.body, null);
  });

  test('JsonRequestMiddleware: non-empty body', () {
    Request request = Request("http://dommain.com", Method.POST);
    request.body = {'name': 'John'};
    JsonRequestMiddleware(request);
    expect(request.headers['content-type'], 'application/json;charset=utf-8');
    expect(request.body, jsonEncode({'name': 'John'}));
  });
}
