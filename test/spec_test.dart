import 'package:api_client/api_client.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTransporter extends Mock implements Transporter {}

void main() {
  test('throws Exception: endpoint not exist', () {
    var spec = Spec();
    spec.onError((request, response, exception) {
      expect(exception, isNotNull);
      expect(exception.toString(), equals('Exception: any does not exist'));
    });
    spec.call("any");
  });

  test('throws Exception: insufficient arguments', () {
    var spec = Spec(endpoints: {"demo": HttpSpec("", "")});
    spec.onError((request, response, exception) {
      expect(exception, isNotNull);
      expect(exception.toString(),
          equals('Exception: Insufficient endpoint arguments'));
    });
    spec.call("demo");
  });

  test('should call all methods', () async {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": get("https://domain.com/users"),
      "post_users": post("https://domain.com/users"),
      "put_users": put("https://domain.com/users"),
      "patch_users": patch("https://domain.com/users"),
      "delete_users": HttpSpec("DeLEte", "https://domain.com/users")
    });

    await spec.call("get_users");
    await spec.call("post_users");
    await spec.call("put_users");
    await spec.call("patch_users");
    await spec.call("delete_users");
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

  test('should call method with global parameters', () async {
    var transporter = MockTransporter();
    var spec = Spec(
        transporter: transporter,
        endpoints: {"get_users": get("https://{{api_domain}}/users")},
        parameters: {"api_domain": "api.domain.com"});

    await spec.call("get_users");
    verifyNever(transporter.get("https://{{api_domain}}/users", headers: {}));
    verify(transporter.get("https://api.domain.com/users", headers: {}))
        .called(1);
  });

  test('should call method with global middlewares', () async {
    var transporter = MockTransporter();
    var spec = Spec(
        transporter: transporter,
        endpoints: {"get_users": get("https://api.domain.com/users")});
    spec.onSend((Request request) {
      request.headers['authorization'] = 'token';
    });

    await spec.call("get_users");
    verify(transporter.get("https://api.domain.com/users",
        headers: {'authorization': 'token'})).called(1);
  });

  test('should call get with headers', () async {
    var transporter = MockTransporter();
    var spec = Spec(
        transporter: transporter,
        endpoints: {"get_users": get("https://domain.com/users")});

    await spec.call("get_users", onSend: (Request request) {
      request.headers['authorization'] = 'token';
    });
    verify(transporter.get("https://domain.com/users",
        headers: {'authorization': 'token'})).called(1);
  });

  test('should call get with parameters', () async {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": get("https://{{api_domain}}/users/{{user_id}}")
    }, parameters: {
      "api_domain": "api.domain.com"
    });

    await spec.call("get_users", parameters: {"user_id": "10001"});
    verifyNever(transporter
        .get("https://{{api_domain}}/users/{{user_id}}", headers: {}));
    verify(transporter.get("https://api.domain.com/users/10001", headers: {}))
        .called(1);
  });
}
