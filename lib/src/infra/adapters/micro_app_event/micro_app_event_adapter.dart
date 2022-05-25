import 'package:flutter/services.dart';

import '../../../entities/events/micro_app_event.dart';

abstract class MicroAppEventAdapter {
  MicroAppEvent parse(MethodCall methodCall);
}
