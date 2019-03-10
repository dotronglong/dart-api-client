import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class Transporter {
  Future<http.Response> get(url, {Map<String, String> headers});

  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<http.Response> put(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<http.Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<http.Response> delete(url, {Map<String, String> headers});
}

class HttpTransporter implements Transporter {
  Future<http.Response> get(url, {Map<String, String> headers}) {
    return http.get(url, headers: headers);
  }

  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return http.post(url, headers: headers, body: body, encoding: encoding);
  }

  Future<http.Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return http.put(url, headers: headers, body: body, encoding: encoding);
  }

  Future<http.Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    return http.patch(url, headers: headers, body: body, encoding: encoding);
  }

  Future<http.Response> delete(url, {Map<String, String> headers}) {
    return http.delete(url, headers: headers);
  }
}