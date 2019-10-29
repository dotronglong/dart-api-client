# Example

## Define Specification

```dart
import 'package:api_client/api_client.dart';

Spec spec = Spec(endpoints: {
  "get_item": get("{{api_url}}/items")
}, parameters: {
   "api_url": "https://api.domain.com"
});
```

## Middlewares

```dart
import 'package:api_client/api_client.dart';
Spec spec = Spec();
spec.onSend((Request request) {
  request.headers[Constants.HEADER_CONTENT_TYPE] =
    Constants.CONTENT_TYPE_JSON_UTF8;
});
```

## Call APIs

```dart
spec.call("get_item").then((response) {
  // do something with response
  // response.statusCode == 200
  // var body = json.decode(utf8.decode(response.bodyBytes));
});
```