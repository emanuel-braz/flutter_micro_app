import 'dart:async';

import '../../../dependencies.dart';
import '../../entities/events/micro_app_event.dart';
import '../../entities/events/micro_app_event_handler.dart';

@pragma('vm:entry-point')
class MicroAppEventDelegate {
  /// registerHandler
  StreamSubscription<MicroAppEvent> registerHandler(
      Stream<MicroAppEvent> stream, MicroAppEventHandler handler) {
    return stream
        .distinct((previousEvent, currentEvent) =>
            handleDistinct(handler, previousEvent, currentEvent))
        .where((event) => handlerHasSameEventTypeOrDynamic(handler, event))
        .where((event) => containsSomeChannelsOrHandlerHasNoChannels(
            handler.channels, event.channels))
        .listen(handler.onEvent,
            onDone: handler.onDone,
            onError: handler.onError,
            cancelOnError: handler.cancelOnError);
  }

  /// pauseAllSubscriptions
  void pauseAllSubscriptions(
      Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> handlers) {
    for (var subscription in handlers.values) {
      if (!subscription.isPaused) subscription.pause();
    }
  }

  /// resumeAllSubscriptions
  void resumeAllSubscriptions(
      Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> handlers) {
    for (var subscription in handlers.values) {
      if (subscription.isPaused) subscription.resume();
    }
  }

  /// unregisterAllSubscriptions
  Future<void> unregisterAllSubscriptions(
      Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>>
          handlers) async {
    for (var entry in handlers.entries) {
      await entry.value.cancel();
    }
    handlers.clear();
  }

  Future<MicroAppEventHandler?> unregisterHandler(
      MicroAppEventHandler handler,
      Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>>
          handlers) async {
    final handlerEntry = handlers[handler];

    try {
      if (handlerEntry != null) {
        handlers.remove(handler);
        await handlerEntry.cancel();
        return handler;
      }
    } catch (e) {
      l.e('Failed to unregister handler', error: e);
    }

    return null;
  }

  /// unregisterSubscription
  Future<void> unregisterSubscription(
      Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> handlers,
      {String? id,
      List<String>? channels}) async {
    final entries = findHandlerEntries(handlers, id: id, channels: channels);

    for (var entry in entries) {
      await entry.value.cancel();
      handlers.remove(entry.key);
    }
  }

  /// findHandlerEntries
  List<MapEntry<MicroAppEventHandler, StreamSubscription<MicroAppEvent>>>
      findHandlerEntries(
    Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> handlers, {
    String? id,
    List<String>? channels,
  }) {
    final entries =
        <MapEntry<MicroAppEventHandler, StreamSubscription<MicroAppEvent>>>[];

    channels = channels ?? [];
    for (var handlerEntry in handlers.entries) {
      if (id != null) {
        if (handlerEntry.key.id != id) {
          continue;
        } else {
          entries.add(handlerEntry);
          continue;
        }
      }

      bool hasChannel =
          containsSomeChannels(handlerEntry.key.channels, channels);

      if (hasChannel) {
        entries.add(handlerEntry);
      }
    }

    return entries;
  }

  bool handleDistinct(MicroAppEventHandler handler, MicroAppEvent previousEvent,
      MicroAppEvent currentEvent) {
    if (handler.distinct == false) return false;
    return !(handler.distinct && previousEvent != currentEvent);
  }

  bool handlerHasSameEventTypeOrDynamic(
      MicroAppEventHandler handler, MicroAppEvent event) {
    final handlerGenericType = handler.runtimeType.toString();

    if (handlerGenericType == r'MicroAppEventHandler<Object?>' ||
        handlerGenericType == r'MicroAppEventHandler<dynamic>') {
      return true;
    }

    var handlerType = handler.runtimeType
        .toString()
        .replaceFirst(r'MicroAppEventHandler<', '')
        .replaceFirst(r'>', '');
    final eventType = event.runtimeType
        .toString()
        .replaceFirst(r'MicroAppEvent<', '')
        .replaceFirst(r'>', '');

    return eventType == handlerType;
  }

  /// shouldHandleEvents
  bool containsSomeChannelsOrHandlerHasNoChannels(
      List<String> handlerChannels, List<String> eventChannels) {
    // If there is no handler channels, so handle all events
    if (handlerChannels.isEmpty) return true;
    return containsSomeChannels(handlerChannels, eventChannels);
  }

  bool containsSomeChannels(
      List<String> handlerChannels, List<String> eventChannels) {
    if (handlerChannels.isEmpty && eventChannels.isEmpty) return true;

    bool handlerChannelsContainsEventChannels = false;
    for (var handlerChannel in handlerChannels) {
      handlerChannelsContainsEventChannels =
          eventChannels.contains(handlerChannel);
      if (handlerChannelsContainsEventChannels) break;
    }
    return handlerChannelsContainsEventChannels;
  }
}
