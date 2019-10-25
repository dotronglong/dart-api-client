import 'package:emitter/emitter.dart';

import '../request.dart';

class SendRequestEvent with CancelledEvent, SynchronizedEvent {
  final Request request;

  SendRequestEvent(this.request);
}
