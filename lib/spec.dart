library api_client;

import 'dart:async';

import 'package:http/http.dart' as http;

import 'replacer.dart';
import 'request.dart';
import 'transporter.dart';


class Spec {
  static const SPEC_URI       = 'uri';
  static const SPEC_METHOD    = 'method';

  static const METHOD_GET     = 'GET';
  static const METHOD_POST    = 'POST';
  static const METHOD_PUT     = 'PUT';
  static const METHOD_PATCH   = 'PATCH';
  static const METHOD_DELETE  = 'DELETE';

  var middlewares = <Function>[];
  var parameters = <String, String>{};
  var endpoints = <String, Map<String, String>>{};
  Replacer replacer = Replacer();
  Transporter transporter;

  Spec({Map<String, Map<String, String>> endpoints, List middlewares, Map<String, String> parameters, Transporter transporter}) {
    if (endpoints != null) this.endpoints = endpoints;
    if (middlewares != null) this.middlewares = middlewares;
    if (parameters != null) this.parameters = parameters;
    if (transporter != null) this.transporter = transporter;
    else this.transporter = HttpTransporter();
  }

  Future<http.Response> request(String name, {Function middleware, Map<String, String> parameters}) {
    if (!this.endpoints.containsKey(name)) {
      throw Exception('$name does not exist');
    }
    Map endpoint = this.endpoints[name];
    if (!endpoint.containsKey(SPEC_URI)
    || !endpoint.containsKey(SPEC_METHOD)) {
      throw Exception('Insufficient endpoint arguments');
    }

    Request request = Request(endpoint[SPEC_URI], endpoint[SPEC_METHOD]);

    middlewares.forEach((f) => f(request));
    if (middleware != null) {
      middleware(request);
    }

    String url = request.toString();
    url = this.replacer.replace(url, this.parameters);
    if (parameters != null) {
      url = this.replacer.replace(url, parameters);
    }

    String method = request.method.toUpperCase();
    switch (method) {
      case METHOD_GET:
        return this.transporter.get(url, headers: request.headers);
      case METHOD_POST:
        return this.transporter.post(url, headers: request.headers, body: request.body);
      case METHOD_PUT:
        return this.transporter.put(url, headers: request.headers, body: request.body);
      case METHOD_PATCH:
        return this.transporter.patch(url, headers: request.headers, body: request.body);
      case METHOD_DELETE:
        return this.transporter.delete(url, headers: request.headers);
      default:
        throw Exception('Method $method is not supported');
    }
  }
}
