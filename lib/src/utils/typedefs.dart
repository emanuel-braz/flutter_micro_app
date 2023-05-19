import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/overlay/micro_overlay_controller.dart';
import '../entities/events/micro_app_event.dart';

typedef WidgetPageBuilder<T extends Widget> = T Function(
    BuildContext context, RouteSettings settings);
typedef MethodCallHandler = Future<dynamic> Function(MethodCall);
typedef MicroAppEventOnEvent = FutureOr<void> Function(MicroAppEvent);
typedef MicroAppEventOnDone = void Function();
typedef MicroAppEventOnError = Function;
typedef MicroAppEventSubscription = StreamSubscription<MicroAppEvent> Function(
    MicroAppEventOnEvent?,
    {bool? cancelOnError,
    MicroAppEventOnDone? onDone,
    MicroAppEventOnError? onError});
typedef MicroAppEmitter = void Function(MicroAppEvent event);
typedef MicroAppBuilder = Widget Function(
    BuildContext context, AsyncSnapshot<MicroAppEvent> microAppEventSnapshot);
typedef MicroAppFloatPageBuilder = Widget Function(
    Widget microPage, MicroAppOverlayController controller);
typedef OnRouteNotRegistered = void Function(String route,
    {Object? arguments, String? type, BuildContext? context});
