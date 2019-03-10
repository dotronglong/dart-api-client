import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:api_client/spec.dart';
import 'package:api_client/request.dart';
import 'package:api_client/transporter.dart';

class MockTransporter extends Mock implements Transporter {}

void main() {
  test('throws Exception: endpoint not exist', () {
    var spec = Spec();
    expect(() => spec.request("any"), throwsException);
  });

  test('throws Exception: insufficient arguments', () {
    var spec = Spec();
    spec.endpoints.putIfAbsent("demo", () => Map());
    expect(() => spec.request("demo"), throwsException);
  });

  test('should call all methods', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "uri": "https://domain.com/users",
        "method": "Get"
      },
      "post_users": {
        "uri": "https://domain.com/users",
        "method": "post"
      },
      "put_users": {
        "uri": "https://domain.com/users",
        "method": "put"
      },
      "patch_users": {
        "uri": "https://domain.com/users",
        "method": "PATCH"
      },
      "delete_users": {
        "uri": "https://domain.com/users",
        "method": "DeLEte"
      }
    });

    spec.request("get_users");
    spec.request("post_users");
    spec.request("put_users");
    spec.request("patch_users");
    spec.request("delete_users");
    verify(transporter.get("https://domain.com/users", headers: {})).called(1);
    verify(transporter.post("https://domain.com/users", headers: {}, body: null)).called(1);
    verify(transporter.put("https://domain.com/users", headers: {}, body: null)).called(1);
    verify(transporter.patch("https://domain.com/users", headers: {}, body: null)).called(1);
    verify(transporter.delete("https://domain.com/users", headers: {})).called(1);
  });

  test('should call method with global parameters', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "uri": "https://{{api_domain}}/users",
        "method": "Get"
      }
    }, parameters: {
      "api_domain": "api.domain.com"
    });

    spec.request("get_users");
    verifyNever(transporter.get("https://{{api_domain}}/users", headers: {}));
    verify(transporter.get("https://api.domain.com/users", headers: {})).called(1);
  });

  test('should call method with global middlewares', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "uri": "https://api.domain.com/users",
        "method": "Get"
      }
    });
    spec.middlewares.add((Request request) {
    request.headers['authorization'] = 'token';
    });

    spec.request("get_users");
    verify(transporter.get("https://api.domain.com/users", headers: {
      'authorization': 'token'
    })).called(1);
  });

  test('should call get with headers', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "uri": "https://domain.com/users",
        "method": "Get"
      }
    });

    spec.request("get_users", middleware: (Request request) {
      request.headers['authorization'] = 'token';
    });
    verify(transporter.get("https://domain.com/users", headers: {
      'authorization': 'token'
    })).called(1);
  });

  test('should call get with parameters', () {
    var transporter = MockTransporter();
    var spec = Spec(transporter: transporter, endpoints: {
      "get_users": {
        "uri": "https://{{api_domain}}/users/{{user_id}}",
        "method": "Get"
      }
    }, parameters: {
      "api_domain": "api.domain.com"
    });

    spec.request("get_users", parameters: {
      "user_id": "10001"
    });
    verifyNever(transporter.get("https://{{api_domain}}/users/{{user_id}}", headers: {}));
    verify(transporter.get("https://api.domain.com/users/10001", headers: {})).called(1);
  });
}
