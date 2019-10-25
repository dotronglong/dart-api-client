import 'package:emitter/emitter.dart';

import '../request.dart';
import '../response.dart';

class ErrorEvent with CancelledEvent, SynchronizedEvent {
  final Request request;
  final Response response;
  final Exception exception;

  ErrorEvent(
      Request this.request, Response this.response, Exception this.exception);
}
