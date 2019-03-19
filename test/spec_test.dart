import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:api_client/api_client.dart';

class MockTransporter extends Mock implements Transporter {}

void main() {
  test('throws Exception: endpoint not exist', () {
    var spec = Spec();
    expect(() => spec.call("any"), throwsException);
  });

  test('throws Exception: insufficient arguments', () {
    var spec = Spec();
    spec.endpoints.putIfAbsent("demo", () => Map());
    expect(() => spec.call("demo"), throwsException);
  });

  test('should call all methods', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {"url": "https://domain.com/users", "method": "Get"},
      "post_users": {"url": "https://domain.com/users", "method": "post"},
      "put_users": {"url": "https://domain.com/users", "method": "put"},
      "patch_users": {"url": "https://domain.com/users", "method": "PATCH"},
      "delete_users": {"url": "https://domain.com/users", "method": "DeLEte"}
    });

    spec.call("get_users");
    spec.call("post_users");
    spec.call("put_users");
    spec.call("patch_users");
    spec.call("delete_users");
    verify(transporter.get("https://domain.com/users", headers: {})).called(1);
    verify(transporter.post("https://domain.com/users",
            headers: {}, body: null))
        .called(1);
    verify(transporter.put("https://domain.com/users", headers: {}, body: null))
        .called(1);
    verify(transporter.patch("https://domain.com/users",
            headers: {}, body: null))
        .called(1);
    verify(transporter.delete("https://domain.com/users", headers: {}))
        .called(1);
  });

  test('should call method with global parameters', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {"url": "https://{{api_domain}}/users", "method": "Get"}
    }, parameters: {
      "api_domain": "api.domain.com"
    });

    spec.call("get_users");
    verifyNever(transporter.get("https://{{api_domain}}/users", headers: {}));
    verify(transporter.get("https://api.domain.com/users", headers: {}))
        .called(1);
  });

  test('should call method with global middlewares', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {"url": "https://api.domain.com/users", "method": "Get"}
    });
    spec.middlewares.add((Request request) {
      request.headers['authorization'] = 'token';
    });

    spec.call("get_users");
    verify(transporter.get("https://api.domain.com/users",
        headers: {'authorization': 'token'})).called(1);
  });

  test('should call get with headers', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {"url": "https://domain.com/users", "method": "Get"}
    });

    spec.call("get_users", middleware: (Request request) {
      request.headers['authorization'] = 'token';
    });
    verify(transporter.get("https://domain.com/users",
        headers: {'authorization': 'token'})).called(1);
  });

  test('should call get with parameters', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "url": "https://{{api_domain}}/users/{{user_id}}",
        "method": "Get"
      }
    }, parameters: {
      "api_domain": "api.domain.com"
    });

    spec.call("get_users", parameters: {"user_id": "10001"});
    verifyNever(transporter
        .get("https://{{api_domain}}/users/{{user_id}}", headers: {}));
    verify(transporter.get("https://api.domain.com/users/10001", headers: {}))
        .called(1);
  });
}
