import 'method.dart';

class HttpSpec {
  String _method;
  String _url;
  Map<String, dynamic> _attributes;

  HttpSpec(String method, String url, {Map<String, dynamic> attributes})
      : this._method = method,
        this._url = url,
        this._attributes = attributes;

  String get method => _method;

  String get url => _url;

  Map<String, dynamic> get attributes => _attributes;
}

HttpSpec get(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.GET, url, attributes: attributes);

HttpSpec post(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.POST, url, attributes: attributes);

HttpSpec put(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.PUT, url, attributes: attributes);

HttpSpec patch(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.PATCH, url, attributes: attributes);

HttpSpec delete(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.DELETE, url, attributes: attributes);

HttpSpec head(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.HEAD, url, attributes: attributes);

HttpSpec options(String url, {Map<String, dynamic> attributes}) =>
    HttpSpec(Method.OPTIONS, url, attributes: attributes);
