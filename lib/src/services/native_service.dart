import 'package:dart_log/dart_log.dart';
import 'package:flutter/services.dart';

import '../entities/micro_app_preferences.dart';
import '../utils/constants/constants.dart';
import '../utils/typedefs.dart';

class MicroAppNativeService {
  MethodChannel? _platform;
  MethodChannel get platform {
    _platform ??= MethodChannel(channel)
      ..setMethodCallHandler(methodCallHandler);
    return _platform as MethodChannel;
  }

  final String channel;

  MethodCallHandler? methodCallHandler;

  MicroAppNativeService(this.channel, {this.methodCallHandler});

  Future<T?> emit<T>(String method, dynamic arguments) async {
    if (!MicroAppPreferences.config.nativeEventsEnabled &&
        method == Constants.methodMicroAppEvent) return null;
    if (!MicroAppPreferences.config.nativeNavigationLogEnabled &&
        method == Constants.methodNavigationLog) return null;

    try {
      return platform.invokeMethod(method, arguments);
    } on MissingPluginException catch (e) {
      logger.e(
          'Platform interaction failed to find a handling plugin.\n'
          'Please, change nativeEventsEnabled to false or implement a native method channel.\n\n'
          'MicroAppPreferences.update(MicroAppPreferences.config.copyWith(nativeEventsEnabled: false));',
          error: e.message);
    } on PlatformException catch (e) {
      logger.e('Platform Exception:', error: e.message);
    } on Exception catch (e) {
      logger.e('Critical Error', error: e);
    }

    return null;
  }
}
