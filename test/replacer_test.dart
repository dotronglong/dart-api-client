import 'package:flutter_test/flutter_test.dart';

import 'package:api_client/replacer.dart';

void main() {
  test('replace parameters', () {
    Replacer replacer = Replacer();
    String source = 'a {{string}} to be replaced';
    String result = replacer.replace(source, {
      'string': 'new_string'
    });
    expect(source, 'a {{string}} to be replaced'); // source must be immutable
    expect(result, 'a new_string to be replaced');
  });

  test('replace parameters with different marker', () {
    Replacer replacer = Replacer(markerStart: '[[', markerEnd: ']]');
    String source = 'a [[string]] to be replaced';
    String result = replacer.replace(source, {
      'string': 'new_string'
    });
    expect(source, 'a [[string]] to be replaced'); // source must be immutable
    expect(result, 'a new_string to be replaced');
  });
}