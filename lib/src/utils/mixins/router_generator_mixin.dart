import 'package:dart_log/dart_log.dart';
import 'package:flutter/material.dart';

import '../../controllers/navigators/navigator_controller.dart';
import '../../entities/router/base_route.dart';

mixin RouterGenerator {
  Route<dynamic>? onGenerateRoute(RouteSettings settings,
      {bool? routeNativeOnError, MicroAppBaseRoute? baseRoute}) {
    if (!NavigatorInstance.shouldTryOpenRoute(
      settings.name ?? '',
      arguments: settings.arguments,
    )) {
      return null;
    }

    PageRoute<dynamic>? pageRoute = NavigatorInstance.getPageRoute(settings,
        routeNativeOnError: routeNativeOnError, baseRoute: baseRoute);
    if (pageRoute == null) {
      logger.e('Error: [onGenerateRoute] PageRoute is null',
          error: 'Route "${settings.name}" not found!');
    }

    return pageRoute;
  }
}
