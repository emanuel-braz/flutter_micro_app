import 'package:flutter/widgets.dart';

import '../../../dependencies.dart';
import '../../../flutter_micro_app.dart';

mixin HandlerRegisterStateMixin<T extends StatefulWidget> on State<T> {
  final List<MicroAppEventHandler> eventHandlersRegistered = [];

  registerEventHandler<R>(MicroAppEventHandler<R> eventHandler) {
    try {
      final eventHandlerCopied =
          eventHandler.copyWith<R>(parentName: widget.runtimeType.toString());
      MicroAppEventController().registerHandler(
        eventHandlerCopied,
      );
      eventHandlersRegistered.add(eventHandlerCopied);
    } catch (e) {
      logger.e(
          '[HandlerRegisterStateMixin] An error occurred while trying to register the event handler',
          error: e);
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

mixin HandlerRegisterMixin on MicroApp {
  MicroAppEventHandler<R>? registerEventHandler<R>(
      MicroAppEventHandler<R> eventHandler) {
    try {
      final eventHandlerCopied = eventHandler.copyWith<R>(parentName: name);
      MicroAppEventController().registerHandler(eventHandlerCopied);
      return eventHandlerCopied;
    } catch (e) {
      logger.e(
          '[HandlerRegisterMixin] An error occurred while trying to register the event handler',
          error: e);
      return null;
    }
  }
}
