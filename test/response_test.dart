import 'dart:typed_data';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockHttpResponse extends Mock implements http.Response {}

void main() {
  test('get HttpResponse properties', () {
    Map<String, String> headers = {"content-type": "application/json"};
    http.Response httpResponse = new MockHttpResponse();
    when(httpResponse.statusCode).thenReturn(400);
    when(httpResponse.persistentConnection).thenReturn(true);
    when(httpResponse.isRedirect).thenReturn(false);
    when(httpResponse.headers).thenReturn(headers);
    when(httpResponse.contentLength).thenReturn(200);
    when(httpResponse.reasonPhrase).thenReturn("OK");
    when(httpResponse.request).thenReturn(null);
    when(httpResponse.body).thenReturn('{"status":"OK"}');
    when(httpResponse.bodyBytes).thenReturn(Uint8List.fromList([10, 20]));

    Response response = Response.fromHttpResponse(httpResponse);
    expect(response.statusCode, equals(400));
    expect(response.persistentConnection, equals(true));
    expect(response.isRedirect, equals(false));
    expect(response.headers, equals(headers));
    expect(response.contentLength, equals(200));
    expect(response.reasonPhrase, equals("OK"));
    expect(response.request, isNull);
    expect(response.body, equals('{"status":"OK"}'));
    expect(response.bodyBytes, equals(Uint8List.fromList([10, 20])));
  });
}
