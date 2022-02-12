import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../entities/events/micro_app_event.dart';
import '../presentation/overlay/micro_overlay_controller.dart';

typedef PageBuilder = Widget Function(BuildContext context, dynamic arguments);
typedef MethodCallHandler = Future<dynamic> Function(MethodCall);
typedef MicroAppEventOnEvent = void Function(MicroAppEvent);
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
