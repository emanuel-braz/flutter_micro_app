// ignore_for_file: cancel_subscriptions
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_micro_app/src/services/native_service.dart';

import 'micro_app_event_delegate.dart';

/// [MicroAppEventController]
class MicroAppEventController {
  final String _channel = Constants.channelAppEvents;
  final StreamController<MicroAppEvent> _controller =
      StreamController.broadcast();
  late MicroAppNativeService _microAppNativeService;
  late MicroAppEventDelegate _handlerRegisterDelegate;

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
    _handlerRegisterDelegate = MicroAppEventDelegate();
    _microAppNativeService = MicroAppNativeService(_channel,
        methodCallHandler: (MethodCall call) async {
      _controller
          .add(MicroAppEvent(name: call.method, payload: call.arguments));
    });
  }

  /// ⚠️ It is used only for unit tests purposes
  @visibleForTesting
  factory MicroAppEventController.$testOnlyPurpose() =>
      MicroAppEventController._();

  /// [MicroAppEvent]
  List<Future> emit<T>(MicroAppEvent<T> event) {
    final futures = <Future>[];

    if (MicroAppPreferences.config.nativeEventsEnabled) {
      final nativeFuture = _microAppNativeService.emit(
          Constants.methodMicroAppEvent, event.toString());
      futures.add(nativeFuture);
    }

    _controller.add(event);
    futures.add(event.asFuture);

    return futures;
  }

  /// register handler
  StreamSubscription<MicroAppEvent>? registerHandler<T>(
      MicroAppEventHandler? handler) {
    if (handler == null) return null;
    final subscription =
        _handlerRegisterDelegate.registerHandler(stream, handler);
    _handlers.putIfAbsent(handler, () => subscription);
    return subscription;
  }

  /// pauseAllHandlers
  void pauseAllHandlers() =>
      _handlerRegisterDelegate.pauseAllSubscriptions(_handlers);

  /// resumeAllHandlers
  void resumeAllHandlers() =>
      _handlerRegisterDelegate.resumeAllSubscriptions(_handlers);

  /// unregisterAllHandlers
  Future<void> unregisterAllHandlers() =>
      _handlerRegisterDelegate.unregisterAllSubscriptions(_handlers);

  /// unregisterHandler
  Future<MicroAppEventHandler?> unregisterHandler(
      {String? id,
      List<String>? channels,
      MicroAppEventHandler? handler}) async {
    if (handler != null) {
      return _handlerRegisterDelegate.unregisterHandler(handler, _handlers);
    }
    await _handlerRegisterDelegate.unregisterSubscription(_handlers,
        id: id, channels: channels);
    return null;
  }

  /// hasHandler
  bool hasHandler({String? id, List<String>? channels}) =>
      _handlerRegisterDelegate
          .findHandlerEntries(handlers, id: id, channels: channels)
          .isNotEmpty;

  /// dispose controller (do not dispose this, if there is not a very specific situation case)
  void dispose() {
    _controller.close();
  }
}
