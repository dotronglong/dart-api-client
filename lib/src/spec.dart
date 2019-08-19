library api_client;

import 'dart:async';

import 'package:http/http.dart' as http;

import 'method.dart';
import 'middleware.dart';
import 'replacer.dart';
import 'request.dart';
import 'transporter.dart';

class Spec {
  static const SPEC_URL = 'url';
  static const SPEC_METHOD = 'method';

  var middlewares = <Middleware>[];
  var parameters = <String, String>{};
  var endpoints = <String, Map<String, String>>{};
  Replacer replacer = Replacer();
  Transporter transporter;

  Spec(
      {Map<String, Map<String, String>> endpoints,
      List<Middleware> middlewares,
      Map<String, String> parameters,
      Transporter transporter}) {
    if (endpoints != null) this.endpoints = endpoints;
    if (middlewares != null) this.middlewares = middlewares;
    if (parameters != null) this.parameters = parameters;
    if (transporter != null) {
      this.transporter = transporter;
    } else {
      this.transporter = HttpTransporter();
    }
  }

  Future<http.Response> call(String name,
      {Function middleware, Map<String, String> parameters}) {
    if (!this.endpoints.containsKey(name)) {
      throw Exception('$name does not exist');
    }
    Map endpoint = this.endpoints[name];
    if (!endpoint.containsKey(SPEC_URL) || !endpoint.containsKey(SPEC_METHOD)) {
      throw Exception('Insufficient endpoint arguments');
    }

    Request request = Request(endpoint[SPEC_URL], endpoint[SPEC_METHOD]);
    if (middleware != null) {
      middleware(request);
    }
    middlewares.forEach((f) => f(request));

    String url = request.toString();
    url = this.replacer.replace(url, this.parameters);
    if (parameters != null) {
      url = this.replacer.replace(url, parameters);
    }

    String method = request.method.toUpperCase();
    switch (method) {
      case Method.GET:
        return this.transporter.get(url, headers: request.headers);
      case Method.POST:
        return this
            .transporter
            .post(url, headers: request.headers, body: request.body);
      case Method.PUT:
        return this
            .transporter
            .put(url, headers: request.headers, body: request.body);
      case Method.PATCH:
        return this
            .transporter
            .patch(url, headers: request.headers, body: request.body);
      case Method.DELETE:
        return this.transporter.delete(url, headers: request.headers);
      default:
        throw Exception('Method $method is not supported');
    }
  }
}
