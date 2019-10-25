import 'package:emitter/emitter.dart';

import '../request.dart';
import '../response.dart';

class ReceiveResponseEvent with CancelledEvent, SynchronizedEvent {
  final Request request;
  final Response response;

  ReceiveResponseEvent(Request this.request, Response this.response);
}
