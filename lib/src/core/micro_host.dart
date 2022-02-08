import 'package:dart_log/dart_log.dart';
import 'package:flutter/material.dart';

import '../controllers/app_event/micro_app_event_controller.dart';
import '../controllers/navigators/navigator_controller.dart';
import '../utils/typedefs.dart';
import 'micro_app.dart';

/// [MicroHost] contract
abstract class MicroHost with MicroApp {
  static bool _microAppsRegistered = false;

  List<MicroApp> get microApps;

  @override
  Map<String, PageBuilder> get pageBuilders => NavigatorInstance.pageBuilders;

  @override
  bool get hasRoutes => pageBuilders.isNotEmpty;

  void registerRoutes() {
    if (_microAppsRegistered) return;

    NavigatorInstance.pageBuilders = {
      for (var page in pages) page.name: page.builder
    };

    _registerEventHandler(this);

    for (MicroApp microapp in microApps) {
      if (microapp.hasRoutes) {
        NavigatorInstance.pageBuilders.addAll(microapp.pageBuilders);
      }
      _registerEventHandler(microapp);
    }
    _microAppsRegistered = true;
  }

  void _registerEventHandler(MicroApp microapp) {
    final handler = microapp.microAppEventHandler;
    MicroAppEventController().registerHandler(handler);
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings,
      {bool? routeNativeOnError}) {
    MaterialPageRoute<dynamic>? pageRoute = NavigatorInstance.getPageRoute(
        settings,
        routeNativeOnError: routeNativeOnError);
    if (pageRoute == null) {
      logger.e('Error: [onGenerateRoute] PageRoute is null',
          error: 'Route "${settings.name}" not found!');
    }

    return pageRoute;
  }
}
