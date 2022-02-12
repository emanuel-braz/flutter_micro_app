import 'package:flutter/widgets.dart';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

mixin HandlerRegisterMixin<T extends StatefulWidget> on State<T> {
  final List<MicroAppEventHandler> _handlers = [];
  List<MicroAppEventHandler> get eventHandlers => _handlers;

  registerEventHandler(MicroAppEventHandler handler) {
    try {
      MicroAppEventController().registerHandler(handler);
      _handlers.add(handler);
    } catch (e) {
      logger.e('Failed to register handler', error: e);
    }
  }

  registerEventHandlers([List<MicroAppEventHandler> handlers = const []]) {
    for (var handler in handlers) {
      registerEventHandler(handler);
    }
  }

  @override
  void dispose() {
    for (var handler in _handlers) {
      MicroAppEventController().unregisterHandler(handler: handler);
    }
    _handlers.clear();
    super.dispose();
  }
}
