import 'dart:async';

import 'package:emitter/emitter.dart';

import 'event/error_event.dart';
import 'event/receive_response_event.dart';
import 'event/send_request_event.dart';
import 'http_spec.dart';
import 'method.dart';
import 'middleware.dart';
import 'replacer.dart';
import 'request.dart';
import 'response.dart';
import 'transporter/http_transporter.dart';
import 'transporter.dart';

class Spec {
  static const SPEC_URL = 'url';
  static const SPEC_METHOD = 'method';
  static const SPEC_ATTRIBUTES = 'attributes';
  static const EVENT_ON_SEND = 'send';
  static const EVENT_ON_RECEIVE = 'receive';
  static const EVENT_ON_ERROR = 'error';

  var parameters = <String, String>{};
  var endpoints = <String, HttpSpec>{};
  Replacer replacer = Replacer();
  Transporter transporter;
  EventEmitter _emitter = EventEmitter();

  Spec(
      {Map<String, HttpSpec> endpoints,
      OnSendMiddleware onSend,
      OnReceiveMiddleware onReceive,
      OnErrorMiddleware onError,
      Map<String, String> parameters,
      Transporter transporter}) {
    if (endpoints != null) this.endpoints = endpoints;
    if (onSend != null) this.onSend(onSend);
    if (onReceive != null) this.onReceive(onReceive);
    if (onError != null) this.onError(onError);
    if (parameters != null) this.parameters = parameters;
    if (transporter != null) {
      this.transporter = transporter;
    } else {
      this.transporter = HttpTransporter();
    }
  }

  void onSend(OnSendMiddleware onSend) {
    this._emitter.on(EVENT_ON_SEND, (event) {
      if (event is SendRequestEvent) {
        onSend(event.request);
      }
      return;
    });
  }

  void onReceive(OnReceiveMiddleware onReceive) {
    this._emitter.on(EVENT_ON_RECEIVE, (event) {
      if (event is ReceiveResponseEvent) {
        onReceive(event.request, event.response);
      }
      return;
    });
  }

  void onError(OnErrorMiddleware onError) {
    this._emitter.on(EVENT_ON_ERROR, (event) {
      if (event is ErrorEvent) {
        onError(event.request, event.response, event.exception);
      }
      return;
    });
  }

  Future<Response> call(String name,
      {Map<String, String> parameters,
      OnSendMiddleware onSend,
      OnReceiveMiddleware onReceive,
      OnErrorMiddleware onError}) async {
    Request request;
    Response response;
    try {
      if (!this.endpoints.containsKey(name)) {
        throw Exception('$name does not exist');
      }
      HttpSpec endpoint = this.endpoints[name];
      if (endpoint.method == null ||
          endpoint.method.isEmpty ||
          endpoint.url == null ||
          endpoint.url.isEmpty) {
        throw Exception('Insufficient endpoint arguments');
      }

      request = Request(endpoint.url, endpoint.method,
          attributes: endpoint.attributes);
      if (onSend != null) {
        onSend(request);
      }
      SendRequestEvent sendRequestEvent = SendRequestEvent(request);
      await this._emitter.emit(EVENT_ON_SEND, sendRequestEvent);

      String url = request.toString();
      url = this.replacer.replace(url, this.parameters);
      if (parameters != null) {
        url = this.replacer.replace(url, parameters);
      }

      String method = request.method.toUpperCase();
      switch (method) {
        case Method.GET:
          response = await this.transporter.get(url, headers: request.headers);
          break;
        case Method.POST:
          response = await this
              .transporter
              .post(url, headers: request.headers, body: request.body);
          break;
        case Method.PUT:
          response = await this
              .transporter
              .put(url, headers: request.headers, body: request.body);
          break;
        case Method.PATCH:
          response = await this
              .transporter
              .patch(url, headers: request.headers, body: request.body);
          break;
        case Method.DELETE:
          response =
              await this.transporter.delete(url, headers: request.headers);
          break;
        default:
          throw Exception('Method $method is not supported');
      }
      ReceiveResponseEvent receiveResponseEvent =
          ReceiveResponseEvent(request, response);
      await this._emitter.emit(EVENT_ON_RECEIVE, receiveResponseEvent);
      if (onReceive != null) {
        onReceive(request, response);
      }
    } catch (exception) {
      ErrorEvent errorEvent;
      if (exception is Error) {
        errorEvent =
            ErrorEvent(request, response, Exception(exception.toString()));
      } else {
        errorEvent = ErrorEvent(request, response, exception);
      }
      await this._emitter.emit(EVENT_ON_ERROR, errorEvent);
    }
    return response;
  }
}
