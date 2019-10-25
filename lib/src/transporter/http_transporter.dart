import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../response.dart';
import '../transporter.dart';

class HttpTransporter implements Transporter {
  Future<Response> get(url, {Map<String, String> headers}) async {
    return Response.fromHttpResponse(await http.get(url, headers: headers));
  }

  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return Response.fromHttpResponse(
        await http.post(url, headers: headers, body: body, encoding: encoding));
  }

  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return Response.fromHttpResponse(
        await http.put(url, headers: headers, body: body, encoding: encoding));
  }

  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    return Response.fromHttpResponse(await http.patch(url,
        headers: headers, body: body, encoding: encoding));
  }

  Future<Response> delete(url, {Map<String, String> headers}) async {
    return Response.fromHttpResponse(await http.delete(url, headers: headers));
  }
}
