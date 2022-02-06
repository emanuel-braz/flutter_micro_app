// ignore_for_file: cancel_subscriptions
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_micro_app/src/services/native_service.dart';

/// [MicroAppEventHandler]
class MicroAppEventHandler<T> extends EventChannelsEquatable {
  final String? id;
  final MicroAppEventOnEvent onEvent;
  final MicroAppEventOnDone? onDone;
  final MicroAppEventOnError? onError;
  final bool? cancelOnError;

  const MicroAppEventHandler(
    this.onEvent, {
    this.onDone,
    this.onError,
    this.cancelOnError,
    List<String> channels = const [],
    this.id,
  }) : super(channels);

  @override
  List<Object?> get props =>
      [onEvent, onDone, onError, cancelOnError, channels, id];
}

/// [MicroAppEventController]
class MicroAppEventController {
  final String _channel = Constants.channelAppEvents;
  final StreamController<MicroAppEvent> _controller =
      StreamController.broadcast();
  late MicroAppNativeService _microAppNativeService;
  late HandlerRegisterHelper _handlerRegisterHelper;

  /// Used to listen all micro app events
  MicroAppEventSubscription get onEvent => _controller.stream.listen;

  /// Can be used to filter events and listen to app events, anywhere
  Stream<MicroAppEvent> get stream => _controller.stream;
  bool get hasSubscribers => _controller.hasListener;
  bool get hasHandlers => _handlers.isNotEmpty;

  final Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> _handlers =
      {};

  /// get all handlers and subscriptions availables
  Map<MicroAppEventHandler, StreamSubscription<MicroAppEvent>> get handlers =>
      _handlers;

  /// Factory instance
  factory MicroAppEventController() => instance;

  /// MicroAppController instance
  static MicroAppEventController instance = MicroAppEventController._();
  MicroAppEventController._() {
    _handlerRegisterHelper = HandlerRegisterHelper();
    _microAppNativeService = MicroAppNativeService(_channel,
        methodCallHandler: (MethodCall call) async {
      _controller
          .add(MicroAppEvent(name: call.method, payload: call.arguments));
    });
  }

  /// ⚠️ It is used only for unit tests purposes
  factory MicroAppEventController.$testOnlyPurpose() =>
      MicroAppEventController._();

  /// [MicroAppEvent]
  void emit(MicroAppEvent event) {
    if (MicroAppPreferences.config.nativeEventsEnabled) {
      _microAppNativeService.emit(
          Constants.methodMicroAppEvent, event.toString());
    }
    _controller.add(event);
  }

  /// register handler
  StreamSubscription<MicroAppEvent>? registerHandler<T>(
      MicroAppEventHandler? handler) {
    if (handler == null) return null;
    final subscription =
        _handlerRegisterHelper.registerHandler(stream, handler);
    _handlers.putIfAbsent(handler, () => subscription);
    return subscription;
  }

  /// pauseAllHandlers
  void pauseAllHandlers() =>
      _handlerRegisterHelper.pauseAllSubscriptions(_handlers);

  /// resumeAllHandlers
  void resumeAllHandlers() =>
      _handlerRegisterHelper.resumeAllSubscriptions(_handlers);

  /// unregisterAllHandlers
  Future<void> unregisterAllHandlers() =>
      _handlerRegisterHelper.unregisterAllSubscriptions(_handlers);

  /// unregisterHandler
  Future<void> unregisterHandler({String? id, List<String>? channels}) =>
      _handlerRegisterHelper.unregisterSubscription(_handlers,
          id: id, channels: channels);

  /// hasHandler
  bool hasHandler({String? id, List<String>? channels}) =>
      _handlerRegisterHelper
          .findHandlerEntries(handlers, id: id, channels: channels)
          .isNotEmpty;

  /// dispose controller (do not dispose this, if there is not a very specific situation case)
  void dispose() {
    _controller.close();
  }
}

class HandlerRegisterHelper {
  /// registerHandler
  StreamSubscription<MicroAppEvent> registerHandler(
      Stream<MicroAppEvent> stream, MicroAppEventHandler handler) {
    return stream
        // TODO: implementar distinct
        // .distinct((previous, event) => event.distinct)
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
