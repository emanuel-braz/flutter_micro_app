import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../entities/micro_app_preferences.dart';
import '../../services/native_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/enums/navigator_status.dart';

/// [MicroAppNavigatorEvent]
class MicroAppNavigatorEvent extends Equatable {
  final String? route;
  final String? type;
  final Object? arguments;

  const MicroAppNavigatorEvent(
      {required this.route, this.arguments, this.type});

  @override
  List<Object?> get props => [route, arguments, type];
}

/// [MicroAppNavigatorEventController] manage all events of micro apps
class MicroAppNavigatorEventController {
  final _route = 'route';
  final _arguments = 'arguments';
  final _type = 'type';

  final String _channelRouterLogger = Constants.channelRouterLoggerEvents;
  final String _channelRouterCommand = Constants.channelRouterCommandEvents;

  final StreamController<MicroAppNavigatorEvent> _flutterLoggerController =
      StreamController.broadcast();

  /// [flutterLoggerStream]
  Stream<MicroAppNavigatorEvent> get flutterLoggerStream =>
      _flutterLoggerController.stream;

  late MicroAppNativeService _nativeLoggerService;
  final StreamController<MethodCall> _nativeLoggerController =
      StreamController.broadcast();

  /// [nativeLoggerStream]
  Stream<MethodCall> get nativeLoggerStream => _nativeLoggerController.stream;

  late MicroAppNativeService _nativeCommandService;
  final StreamController<MethodCall> _nativeCommandController =
      StreamController.broadcast();

  /// [nativeCommandStream]
  Stream<MethodCall> get nativeCommandStream => _nativeCommandController.stream;

  /// [MicroAppNavigatorEventController]
  MicroAppNavigatorEventController() {
    _nativeLoggerService = MicroAppNativeService(_channelRouterLogger,
        methodCallHandler: (MethodCall call) async {
      if (MicroAppPreferences.config.nativeEventsEnabled) {
        _nativeLoggerController.add(call);
      }
    });

    _nativeCommandService = MicroAppNativeService(_channelRouterCommand,
        methodCallHandler: (MethodCall call) async {
      if (MicroAppPreferences.config.nativeEventsEnabled) {
        _nativeCommandController.add(call);
      }
    });
  }

  /// [logNavigationEvent]
  Future<T?> logNavigationEvent<T>(String? route,
      {Object? arguments, String? type}) async {
    _flutterLoggerController.add(
        MicroAppNavigatorEvent(route: route, arguments: arguments, type: type));

    if (MicroAppPreferences.config.nativeNavigationLogEnabled) {
      return _nativeLoggerService.emit(
          Constants.methodNavigationLog,
          jsonEncode(
              {_route: route, _arguments: arguments.toString(), _type: type}));
    }

    return null;
  }

  /// [pushNamedNative]
  Future<T?> pushNamedNative<T>(String route,
      {Object? arguments, String? type}) async {
    if (MicroAppPreferences.config.nativeNavigationCommandEnabled) {
      return _nativeCommandService.emit(
          Constants.methodNavigationCommand,
          jsonEncode({
            _route: route,
            _arguments: arguments?.toString(),
            _type: type ?? MicroAppNavigationType.pushNamedNative.name
          }));
    }

    return null;
  }

  /// dispose stream controllers (do not dispose this, if there is no a very specific situation case)
  void dispose() {
    _flutterLoggerController.close();
    _nativeLoggerController.close();
    _nativeCommandController.close();
  }
}
