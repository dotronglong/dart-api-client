# Example

## Define Specification

```dart
import 'package:api_client/api_client.dart';

Spec spec = Spec(endpoints: {
  "get_item": {
    "url": "{{api_url}}/items",
    "method": "get"
  }
}, parameters: {
   "api_url": "https://api.domain.com"
});
```

## Middlewares

```dart
import 'package:api_client/api_client.dart';
Spec spec = Spec();
spec.middlewares.add((Request request) {
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