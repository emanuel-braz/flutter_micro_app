// ignore_for_file: cancel_subscriptions
// ignore_for_file: todo
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_micro_app/dependencies.dart';
import 'package:flutter_micro_app/flutter_micro_app.dart';
import 'package:flutter_micro_app/src/services/native_service.dart';

import '../../infra/adapters/micro_app_event/micro_app_event_adapter.dart';
import '../../infra/adapters/micro_app_event/micro_app_event_json_adapter.dart';
import 'micro_app_event_delegate.dart';

/// [MicroAppEventController]
class MicroAppEventController {
  final String _channel = Constants.channelAppEvents;
  final StreamController<MicroAppEvent> _controller =
      StreamController.broadcast();
  late MicroAppNativeService _microAppNativeService;
  late MicroAppEventDelegate _handlerRegisterDelegate;
  final Map<String, GenericMicroAppEventController> _webviewControllers = {};
  Map<String, GenericMicroAppEventController> get webviewControllers =>
      _webviewControllers;

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
  MicroAppEventController._({bool isTest = false}) {
    _handlerRegisterDelegate = MicroAppEventDelegate();

    _microAppNativeService = MicroAppNativeService(_channel,
        methodCallHandler: (MethodCall call) async {
      MicroAppEventAdapter adapter = MicroAppEventJsonAdapter();
      final event = adapter.parse(call);
      _controller.add(event);

      try {
        // It dispatchs event to all webviews
        for (var webviewController in _webviewControllers.values) {
          webviewController.emit(event);
        }
      } catch (e) {
        logger.e('An error occurred while dispatching events to webviews',
            error: e);
      }
    });

    if (!isTest) {
      // Receive micro app events from devtools
      registerExtension(Constants.devtoolsToExtensionMicroAppEvent,
          (method, parameters) async {
        try {
          _handleDevToolsEvent(method, parameters);
          return ServiceExtensionResponse.result(jsonEncode({'success': true}));
        } catch (e) {
          logger.e('An error occurred while dispatching events to webviews',
              error: e);

          return ServiceExtensionResponse.result(
              jsonEncode({'success': false, 'error': e}));
        }
      });

      // It receives requests to return MicroBoardData to devtools
      registerExtension(Constants.devtoolsToExtensionUpdate,
          (method, parameters) async {
        return ServiceExtensionResponse.result(getMicroBoardData());
      });
    }
  }

  String getMicroBoardData() {
    final microBoard = MicroBoard();

    final microApps = microBoard.getMicroBoardApps;
    final orphanHandlers = microBoard.getOrphanHandlers();
    final widgetHandlers = microBoard.getWidgetsHandlers();
    final webviewControllers = microBoard.getWebviewControllers();

    final microAppsMap = microApps.map((e) => e.toMap()).toList();
    final orphanHandlersMap = orphanHandlers.map((e) => e.toMap()).toList();
    final widgetHandlersMap = widgetHandlers.map((e) => e.toMap()).toList();
    final webviewControllersMap =
        webviewControllers.map((e) => e.toMap()).toList();

    final mapData = {
      'micro_apps': microAppsMap,
      'orphan_event_handlers': orphanHandlersMap,
      'widget_event_handlers': widgetHandlersMap,
      'webview_controllers': webviewControllersMap,
    };

    final jsonData = jsonEncode(mapData);
    return jsonData;
  }

  notifyDevtoolsMicroBoardChanged() {
    try {
      // TODO: Not compatible with flutter stable version yet
      // serviceManager.callServiceExtensionOnMainIsolate(
      //   Constants.extensionToDevtoolsMicroBoardChanged,
      //   {
      //     'data': getMicroBoardData(),
      //   },
      // );
    } catch (e) {
      logger.e('An error occurred while dispatching events to Devtools',
          error: e);
    }
  }

  bool _handleDevToolsEvent(String method, Map<String, String> parameters) {
    final eventMap = jsonDecode(parameters['event']!);
    final event = MicroAppEvent.fromMap(eventMap);
    MicroAppEventController().emit(event);
    return true;
  }

  /// ⚠️ It is used only for unit tests purposes
  @visibleForTesting
  factory MicroAppEventController.$testOnlyPurpose() =>
      MicroAppEventController._(isTest: true);

  /// [MicroAppEvent] the event that is emitted to the micro apps (Managed by event broker)
  List<Future> emit<T>(MicroAppEvent<T> event, {Duration? timeout}) {
    final futures = <Future>[];

    // Native mobile events
    if (MicroAppPreferences.config.nativeEventsEnabled) {
      final nativeFuture = _microAppNativeService.emit(
          Constants.methodMicroAppEvent, event.toMap());
      if (timeout == null) {
        futures.add(nativeFuture);
      } else {
        futures.add(nativeFuture.timeout(timeout));
      }
    }

    // Webview events
    for (var webviewController in _webviewControllers.values) {
      final webFuture = webviewController.emit(event, timeout: timeout);
      futures.add(webFuture);
    }

    // Flutter events
    _controller.add(event);
    if (timeout == null) {
      futures.add(event.asFuture);
    } else {
      futures.add(event.asFuture.timeout(timeout));
    }

    return futures;
  }

  /// register handler
  StreamSubscription<MicroAppEvent>? registerHandler<T>(
      MicroAppEventHandler? handler) {
    if (handler == null) return null;
    final subscription =
        _handlerRegisterDelegate.registerHandler(stream, handler);
    _handlers.putIfAbsent(handler, () => subscription);

    notifyDevtoolsMicroBoardChanged();
    return subscription;
  }

  /// pauseAllHandlers
  void pauseAllHandlers() =>
      _handlerRegisterDelegate.pauseAllSubscriptions(_handlers);

  /// resumeAllHandlers
  void resumeAllHandlers() =>
      _handlerRegisterDelegate.resumeAllSubscriptions(_handlers);

  /// unregisterAllHandlers
  Future<void> unregisterAllHandlers() async {
    await _handlerRegisterDelegate.unregisterAllSubscriptions(_handlers);
    notifyDevtoolsMicroBoardChanged();
  }

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

    notifyDevtoolsMicroBoardChanged();
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

  /// registerWebviewController
  GenericMicroAppEventController registerWebviewController(
      {required String id,
      required GenericMicroAppEventController controller}) {
    notifyDevtoolsMicroBoardChanged();
    return _webviewControllers[id] = controller;
  }

  /// unregisterWebviewController
  GenericMicroAppEventController? unregisterWebviewController(
      {required String id}) {
    final controller = _webviewControllers.remove(id);
    if (controller != null) {
      controller.dispose();
      return controller;
    }

    notifyDevtoolsMicroBoardChanged();
    return null;
  }
}
