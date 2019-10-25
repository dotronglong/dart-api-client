import 'dart:async';
import 'dart:convert';

import 'response.dart';

abstract class Transporter {
  Future<Response> get(url, {Map<String, String> headers});

  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding});

  Future<Response> delete(url, {Map<String, String> headers});
}
