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
import 'transporter.dart';

class Spec {
  static const _ON_SEND = 'send';
  static const _ON_RECEIVE = 'receive';
  static const _ON_ERROR = 'error';

  Map<String, String> _parameters = {};
  Map<String, HttpSpec> _endpoints = {};
  Replacer _replacer = Replacer.factory();
  Transporter _transporter = Transporter.factory();
  EventEmitter _emitter = EventEmitter();

  Spec(
      {Map<String, HttpSpec> endpoints,
      Map<String, String> parameters,
      Replacer replacer,
      Transporter transporter,
      OnSendMiddleware onSend,
      OnReceiveMiddleware onReceive,
      OnErrorMiddleware onError}) {
    if (endpoints != null) this._endpoints = endpoints;
    if (parameters != null) this._parameters = parameters;
    if (replacer != null) this._replacer = replacer;
    if (transporter != null) this._transporter = transporter;
    if (onSend != null) this.onSend(onSend);
    if (onReceive != null) this.onReceive(onReceive);
    if (onError != null) this.onError(onError);
  }

  void onSend(OnSendMiddleware onSend) {
    this._emitter.on(_ON_SEND, (event) {
      if (event is SendRequestEvent) {
        onSend(event.request);
      }
      return;
    });
  }

  void onReceive(OnReceiveMiddleware onReceive) {
    this._emitter.on(_ON_RECEIVE, (event) {
      if (event is ReceiveResponseEvent) {
        onReceive(event.request, event.response);
      }
      return;
    });
  }

  void onError(OnErrorMiddleware onError) {
    this._emitter.on(_ON_ERROR, (event) {
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
      if (!this._endpoints.containsKey(name)) {
        throw Exception('$name does not exist');
      }
      HttpSpec endpoint = this._endpoints[name];
      if (endpoint.method == null ||
          endpoint.method.isEmpty ||
          endpoint.url == null ||
          endpoint.url.isEmpty) {
        throw Exception('Insufficient endpoint arguments');
      }

      request = Request(endpoint.url, endpoint.method,
          attributes: endpoint.attributes);
      request.set("name", name);
      if (onSend != null) {
        onSend(request);
      }
      SendRequestEvent sendRequestEvent = SendRequestEvent(request);
      await this._emitter.emit(_ON_SEND, sendRequestEvent);

      String url = request.toString();
      url = this._replacer.replace(url, this._parameters);
      if (parameters != null) {
        url = this._replacer.replace(url, parameters);
      }

      String method = request.method.toUpperCase();
      switch (method) {
        case Method.GET:
          response = await this._transporter.get(url, headers: request.headers);
          break;
        case Method.POST:
          response = await this
              ._transporter
              .post(url, headers: request.headers, body: request.body);
          break;
        case Method.PUT:
          response = await this
              ._transporter
              .put(url, headers: request.headers, body: request.body);
          break;
        case Method.PATCH:
          response = await this
              ._transporter
              .patch(url, headers: request.headers, body: request.body);
          break;
        case Method.DELETE:
          response =
              await this._transporter.delete(url, headers: request.headers);
          break;
        default:
          throw Exception('Method $method is not supported');
      }
      ReceiveResponseEvent receiveResponseEvent =
          ReceiveResponseEvent(request, response);
      await this._emitter.emit(_ON_RECEIVE, receiveResponseEvent);
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
      await this._emitter.emit(_ON_ERROR, errorEvent);
      if (onError != null) {
        onError(request, response, errorEvent.exception);
      }
    }
    return response;
  }
}
