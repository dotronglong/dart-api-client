# api_client
[![Build Status](https://travis-ci.org/dotronglong/dart-api-client.svg?branch=master)](https://travis-ci.org/dotronglong/dart-api-client)

A schema api's client

### Set up Spec

```dart
final Spec spec = Spec(
      endpoints: {
        "get_pet": get("{{api_url}}/{{version}}/pet/{{pet_id}}"),
      },
      parameters: {
        "api_url": "https://petstore.swagger.io",
        "version": "v2",
      },
      onSend: (Request request) {
        JsonRequestMiddleware(request);
        request.set("start_time", DateTime.now().millisecondsSinceEpoch);
      },
      onReceive: (Request request, Response response) {
        int startTime = request.get("start_time");
        int endTime = DateTime.now().millisecondsSinceEpoch;
        print(
            "Request ${response.httpResponse.request.url.toString()} is completed in ${endTime - startTime} (ms)");
      });
```

### Call API

```dart
spec.call("get_pet", parameters: {"pet_id": 123})
    .then((response) {
  if (response.statusCode == 200) {
     print(json.decode(utf8.decode(response.bodyBytes)));
  }
});
```

**Function Arguments** of `call`
- `name`: (requires) name of spec
- `parameters`: (optional) contextual parameters for current call
- `onSend`, `onReceive`: (optional) see `Events`

### Events

- `onSend(Request request)` executes before request is sent
- `onReceive(Request request, Response response)` executes after receiving response
- `onError(Request request, Response response, Exception exception)` executes when there is an error
