import 'request.dart';
import 'response.dart';

typedef OnSendMiddleware = void Function(Request request);
typedef OnReceiveMiddleware = void Function(Request request, Response response);
typedef OnErrorMiddleware = void Function(
    Request request, Response response, Exception exception);
