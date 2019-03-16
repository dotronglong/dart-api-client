import 'package:test/test.dart';

import 'package:api_client/api_client.dart';

void main() {
  test('toString without query', () {
    Request request = Request('https://api.domain.com', 'Get');
    expect(request.toString(), 'https://api.domain.com');
  });

  test('toString with query', () {
    Request request = Request('https://api.domain.com', 'Get');
    expect(request.toString(), 'https://api.domain.com');

    request.query['baz'] = 'foo';
    request.query['bar'] = 'foo';
    expect(request.toString(), 'https://api.domain.com?baz=foo&bar=foo');
  });

  test('toString with query but has current query', () {
    Request request = Request('https://api.domain.com?foo=bar', 'Get');
    request.query['baz'] = 'foo';
    request.query['bar'] = 'foo';
    expect(
        request.toString(), 'https://api.domain.com?foo=bar&baz=foo&bar=foo');
  });
}
