import 'package:flutter/widgets.dart';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

mixin HandlerRegisterMixin<T extends StatefulWidget> on State<T> {
  final List<MicroAppEventHandler> eventHandlersRegistered = [];
  List<MicroAppEventHandler> get eventHandlers;

  @override
  void initState() {
    _registerEventHandlers();
    super.initState();
  }

  registerEventHandler(MicroAppEventHandler handler) {
    try {
      MicroAppEventController().registerHandler(handler);
      eventHandlersRegistered.add(handler);
    } catch (e) {
      logger.e('Failed to register handler', error: e);
    }
  }

  _registerEventHandlers() {
    for (var handler in eventHandlers) {
      registerEventHandler(handler);
    }
  }

  void unregisterEventHandlers() {
    for (var handler in eventHandlersRegistered) {
      MicroAppEventController().unregisterHandler(handler: handler);
    }
    eventHandlersRegistered.clear();
  }

  @override
  void dispose() {
    unregisterEventHandlers();
    super.dispose();
  }
}
